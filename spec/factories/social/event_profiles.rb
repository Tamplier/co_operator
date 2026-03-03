# frozen_string_literal: true

# == Schema Information
#
# Table name: social_event_profiles
#
#  id                 :integer          not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  account_profile_id :integer          not null
#  social_event_id    :integer          not null
#
# Indexes
#
#  idx_on_social_event_id_account_profile_id_e7370d494a  (social_event_id,account_profile_id) UNIQUE
#  index_social_event_profiles_on_account_profile_id     (account_profile_id)
#  index_social_event_profiles_on_social_event_id        (social_event_id)
#
# Foreign Keys
#
#  account_profile_id  (account_profile_id => account_profiles.id)
#  social_event_id     (social_event_id => social_events.id)
#
FactoryBot.define do
  factory :social_event_profile, class: 'Social::EventProfile' do
    social_event { nil }
    account_profile { nil }
  end
end
