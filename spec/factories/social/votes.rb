# frozen_string_literal: true

# == Schema Information
#
# Table name: social_votes
#
#  id                 :bigint           not null, primary key
#  decision           :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  account_profile_id :integer          not null
#  social_request_id  :integer          not null
#
# Indexes
#
#  index_social_votes_on_account_profile_id                        (account_profile_id)
#  index_social_votes_on_social_request_id                         (social_request_id)
#  index_social_votes_on_social_request_id_and_account_profile_id  (social_request_id,account_profile_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (account_profile_id => account_profiles.id)
#  fk_rails_...  (social_request_id => social_requests.id)
#
FactoryBot.define do
  factory :social_vote, class: 'Social::Vote' do
    social_request { nil }
    account_profile { nil }
    decision { 1 }
  end
end
