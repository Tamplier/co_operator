# frozen_string_literal: true

# == Schema Information
#
# Table name: stores
#
#  id                   :bigint           not null, primary key
#  game_link_pattern    :string(255)      not null
#  image_link_pattern   :jsonb
#  profile_link_pattern :string(255)      not null
#  title                :string(255)      not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
FactoryBot.define do
  factory :store do
    title { Faker::Lorem.characters(number: 10) }
    game_link_pattern { Faker::Internet.url }
    profile_link_pattern { Faker::Internet.url }

    trait :steam do
      title { 'Steam' }
    end
  end
end
