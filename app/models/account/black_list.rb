# frozen_string_literal: true

# == Schema Information
#
# Table name: account_black_lists
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  requester_id :integer          not null
#  target_id    :integer          not null
#
# Indexes
#
#  index_account_black_lists_on_requester_id                (requester_id)
#  index_account_black_lists_on_requester_id_and_target_id  (requester_id,target_id) UNIQUE
#  index_account_black_lists_on_target_id                   (target_id)
#
# Foreign Keys
#
#  requester_id  (requester_id => account_profiles.id)
#  target_id     (target_id => account_profiles.id)
#
module Account
  class BlackList < ApplicationRecord
    belongs_to :requester, class_name: 'Account::Profile'
    belongs_to :target, class_name: 'Account::Profile'
  end
end
