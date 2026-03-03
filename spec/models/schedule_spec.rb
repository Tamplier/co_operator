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
require 'rails_helper'

RSpec.describe Schedule, type: :model do
  context 'after create or update' do
    let(:profile) { create(:account_profile) }
    let(:start_time) { Time.now }
    let(:end_time) { start_time + 1.hour }
    let(:ice_cube_schedule) { IceCube::Schedule.new(start_time, end_time: end_time) }
    let(:period) { 2 }

    %i[weekly hourly monthly].each do |period_base|
      context "when period is #{period_base}" do
        let(:rule) { IceCube::Rule.send(period_base, period) }

        it 'updates occurrences list' do
          schedule = profile.schedules.create!(
            start_time: start_time,
            end_time: end_time,
            reference_date: start_time,
            recurrence_rule: rule,
            active: true
          )

          ice_cube_schedule.add_recurrence_rule(rule)

          expected_count = ice_cube_schedule.occurrences_between(
            schedule.generation_start_date,
            schedule.generation_end_date
          ).count

          expect(schedule.reload.schedule_occurrences.count).to eq(expected_count)
        end
      end
    end
  end
end
