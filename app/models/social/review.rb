# frozen_string_literal: true

# == Schema Information
#
# Table name: social_reviews
#
#  id          :integer          not null, primary key
#  rating      :integer          not null
#  target_type :string           not null
#  text        :string(2048)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  author_id   :integer          not null
#  target_id   :integer          not null
#
# Indexes
#
#  idx_on_author_id_target_id_target_type_f114ef90b0  (author_id,target_id,target_type) UNIQUE
#  index_social_reviews_on_author_id                  (author_id)
#  index_social_reviews_on_target                     (target_type,target_id)
#
# Foreign Keys
#
#  author_id  (author_id => account_profile.id)
#

module Social
  class Review < ApplicationRecord
    belongs_to :author
    belongs_to :target

    validates :rating, numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 5
    }
  end
end
