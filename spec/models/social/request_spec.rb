# frozen_string_literal: true

# == Schema Information
#
# Table name: social_requests
#
#  id                :bigint           not null, primary key
#  request_type      :integer
#  status            :integer          default("in_review")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  social_event_id   :integer          not null
#  target_profile_id :integer          not null
#
# Indexes
#
#  idx_on_target_profile_id_social_event_id_request_ty_f6ff4f78f1  (target_profile_id,social_event_id,request_type) UNIQUE WHERE (status <> 1)
#  index_social_requests_on_social_event_id                        (social_event_id)
#  index_social_requests_on_target_profile_id                      (target_profile_id)
#
# Foreign Keys
#
#  fk_rails_...  (social_event_id => social_events.id)
#  fk_rails_...  (target_profile_id => account_profiles.id)
#
require 'rails_helper'

RSpec.describe Social::Request, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
