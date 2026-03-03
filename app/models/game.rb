# frozen_string_literal: true

# == Schema Information
#
# Table name: games
#
#  id          :integer          not null, primary key
#  description :string(300)      not null
#  rating      :float
#  title       :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Game < ApplicationRecord
  has_many :external_ids, as: :owner, dependent: :destroy
  has_many :stores, through: :external_ids

  has_one_attached :preview

  validates :title, presence: true
  validates :description, presence: true
  validates :rating, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 5.0
  }, allow_nil: true

  accepts_nested_attributes_for :external_ids, allow_destroy: true
end
