# frozen_string_literal: true

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
