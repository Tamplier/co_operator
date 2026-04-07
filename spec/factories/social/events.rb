# frozen_string_literal: true

# == Schema Information
#
# Table name: social_events
#
#  id          :bigint           not null, primary key
#  duration    :integer          not null
#  max_players :integer
#  name        :string
#  start_date  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  game_id     :integer          not null
#  language_id :integer          not null
#
# Indexes
#
#  index_social_events_on_game_id      (game_id)
#  index_social_events_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#  fk_rails_...  (language_id => languages.id)
#
FactoryBot.define do
  factory :social_event, class: 'Social::Event' do
    language { create(:language) }
    game { create(:game) }
    name { Faker::Lorem.word }
    max_players { 5 }
    start_date { Time.now + 5.minutes }
    duration { 1.hour }

    trait :with_users do
      transient do
        users_count { 4 }
      end

      after(:create) do |event, evaluator|
        profiles = create_list(:account_profile, evaluator.users_count)
        event.profiles << profiles
        event.save!
      end
    end
  end
end
