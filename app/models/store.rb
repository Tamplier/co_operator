# frozen_string_literal: true

# == Schema Information
#
# Table name: stores
#
#  id                   :integer          not null, primary key
#  game_link_pattern    :string(255)      not null
#  profile_link_pattern :string(255)      not null
#  title                :string(255)      not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Store < ApplicationRecord
  has_many :external_ids, dependent: :destroy
  has_many :games, through: :external_ids, source: :owner, source_type: 'Game'
  has_one_attached :logo do |attachable|
    attachable.variant :thumb, resize_to_limit: [40, 40]
    attachable.variant :medium, resize_to_limit: [100, 100]
  end

  validates :title, presence: true
  validates :game_link_pattern, presence: true
  validates :profile_link_pattern, presence: true
end
