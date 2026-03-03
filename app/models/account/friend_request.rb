# frozen_string_literal: true

# == Schema Information
#
# Table name: account_friend_requests
#
#  id           :integer          not null, primary key
#  status       :integer          default("in_review"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  recipient_id :integer          not null
#  requester_id :integer          not null
#
# Indexes
#
#  index_account_friend_requests_on_recipient_id                   (recipient_id)
#  index_account_friend_requests_on_requester_id                   (requester_id)
#  index_account_friend_requests_on_requester_id_and_recipient_id  (requester_id,recipient_id) UNIQUE WHERE status != 1
#
# Foreign Keys
#
#  recipient_id  (recipient_id => account_profiles.id)
#  requester_id  (requester_id => account_profiles.id)
#
module Account
  class FriendRequest < ApplicationRecord
    enum :status, { in_review: 0, rejected: 1, accepted: 2 }

    belongs_to :requester, class_name: 'Account::Profile'
    belongs_to :recipient, class_name: 'Account::Profile'

    validate :no_reverse_active_request, on: %i[create update]

    private

    def no_reverse_active_request
      exists = Account::FriendRequest.not_rejected
                                     .exists?(requester: recipient, recipient: requester)

      return unless exists

      errors.add(:recipient, 'The counter request already exists or has been accepted')
    end
  end
end
