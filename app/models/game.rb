# frozen_string_literal: true

# == Schema Information
#
# Table name: games
#
#  id               :bigint           not null, primary key
#  description      :string(300)
#  last_modified    :bigint           default(0)
#  rating           :float
#  title            :string(255)      not null
#  title_normalized :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_games_on_title_normalized_trgm  (title_normalized) USING gin
#
class Game < ApplicationRecord
  has_many :external_ids, as: :owner, dependent: :destroy
  has_many :stores, through: :external_ids

  has_one_attached :preview do |attachable|
    attachable.variant :small,  resize_to_limit: [120, 45]
    attachable.variant :medium, resize_to_limit: [231, 81]
    attachable.variant :large,  resize_to_limit: [460, 215]
  end

  validates :title, presence: true
  validates :rating, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 5.0
  }, allow_nil: true

  accepts_nested_attributes_for :external_ids, allow_destroy: true

  def self.search_by_title(query, limit = 5)
    return if query.blank?

    query = query.strip.downcase.gsub(/[^a-zа-я0-9\s]/i, ' ')

    order_sql = sanitize_sql_array(
      [
        'GREATEST(similarity(title_normalized, ?), word_similarity(?, title_normalized)) DESC',
        query, query
      ]
    )

    where(
      'similarity(title_normalized, ?) > 0.3 OR word_similarity(?, title_normalized) > 0.35',
      query, query
    )
      .order(Arel.sql(order_sql))
      .limit(limit)
  end

  def preview_url(variant = :medium)
    if preview.attached?
      rails_representation_url(preview.variant(variant).processed)
    else
      store = stores.first(&:supports_external_image?)
      return if store.blank?

      external_id = external_ids.find_by(store: store).external_id
      store.image_link(external_id, variant)
    end
  end
end
