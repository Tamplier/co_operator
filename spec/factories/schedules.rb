# frozen_string_literal: true

# == Schema Information
#
# Table name: schedules
#
#  id              :integer          not null, primary key
#  active          :boolean          not null
#  end_time        :time             not null
#  owner_type      :string           not null
#  recurrence_rule :string(255)
#  reference_date  :datetime         not null
#  start_time      :time             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  owner_id        :integer          not null
#
# Indexes
#
#  idx_on_owner_id_owner_type_reference_date_start_tim_8e339f2eb8  (owner_id,owner_type,reference_date,start_time) UNIQUE
#  index_schedules_on_owner                                        (owner_type,owner_id)
#
FactoryBot.define do
  factory :schedule do
  end
end
