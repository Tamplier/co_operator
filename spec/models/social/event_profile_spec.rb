# frozen_string_literal: true

# == Schema Information
#
# Table name: social_event_profiles
#
#  id                 :bigint           not null, primary key
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
#  fk_rails_...  (account_profile_id => account_profiles.id)
#  fk_rails_...  (social_event_id => social_events.id)
#
require 'rails_helper'

RSpec.describe Social::EventProfile, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
