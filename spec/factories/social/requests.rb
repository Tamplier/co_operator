# frozen_string_literal: true

# == Schema Information
#
# Table name: social_requests
#
#  id                :integer          not null, primary key
#  request_type      :integer
#  status            :integer          default("in_review")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  social_event_id   :integer          not null
#  target_profile_id :integer          not null
#
# Indexes
#
#  idx_on_target_profile_id_social_event_id_request_ty_f6ff4f78f1  (target_profile_id,social_event_id,request_type) UNIQUE WHERE status != 1
#  index_social_requests_on_social_event_id                        (social_event_id)
#  index_social_requests_on_target_profile_id                      (target_profile_id)
#
# Foreign Keys
#
#  social_event_id    (social_event_id => social_events.id)
#  target_profile_id  (target_profile_id => account_profiles.id)
#
FactoryBot.define do
  factory :social_request, class: 'Social::Request' do
    transient do
      decision { 'positive' }
    end

    request_type { 'kick_event' }
    social_event { create(:social_event, :with_users) }
    status { 'in_review' }

    Social::Request.statuses.keys.each do |status_name|
      trait status_name do
        status { status_name }
      end
    end

    trait :kick_request do
      request_type { 'kick_event' }
      target_profile { social_event.profiles.last }
    end

    trait :join_request do
      request_type { 'join_event' }
      target_profile { create(:account_profile) }
    end

    trait :one_vote_away_from_closing do
      after(:create) do |request, evaluator|
        profiles_count = request.social_event.profiles.count
        votes_required = (profiles_count / 2.0).floor + 1
        drop_count = profiles_count - votes_required
        request.social_event.profiles.drop(drop_count).each do |profile|
          request.votes.create!(account_profile: profile, decision: evaluator.decision)
        end
      end
    end
  end
end
