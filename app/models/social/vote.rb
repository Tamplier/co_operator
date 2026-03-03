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
module Social
  class Vote < ApplicationRecord
    belongs_to :social_request, class_name: 'Social::Request'
    belongs_to :account_profile, class_name: 'Account::Profile'

    enum :decision, { negative: 1, positive: 2 }
  end
end
