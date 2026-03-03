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
module Social
  class Request < ApplicationRecord
    belongs_to :target_profile, class_name: 'Account::Profile'
    belongs_to :social_event, class_name: 'Social::Event'

    has_many :votes, class_name: 'Social::Vote', inverse_of: 'social_request', dependent: :destroy
    has_many :profiles, through: :social_event

    enum :request_type, { join_event: 0, kick_event: 1 }
    enum :status, { in_review: 0, rejected: 1, accepted: 2 }

    def votes_stat
      stats = votes.group(:decision).count
      {
        max_votes: profiles.count,
        negative_votes: stats['negative'] || 0,
        positive_votes: stats['positive'] || 0
      }
    end
  end
end
