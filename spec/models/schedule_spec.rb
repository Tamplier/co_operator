# frozen_string_literal: true

# == Schema Information
#
# Table name: schedules
#
#  id              :bigint           not null, primary key
#  active          :boolean          not null
#  duration        :integer          not null
#  owner_type      :string           not null
#  recurrence_rule :string(255)
#  reference_date  :datetime         not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  owner_id        :integer          not null
#
# Indexes
#
#  index_schedules_on_owner  (owner_type,owner_id)
#
require 'rails_helper'

RSpec.describe Schedule, type: :model do
  context 'after create or update' do
    let(:profile) { create(:account_profile) }
    let(:reference_date) { Time.now }
    let(:duration) { 1.hour }
    let(:ice_cube_schedule) { IceCube::Schedule.new(reference_date, duration: duration) }
    let(:period) { 1 }

    %i[weekly].each do |period_base|
      context "when period is #{period_base}" do
        let(:rule) { IceCube::Rule.send(period_base, period) }

        it 'updates occurrences list' do
          schedule = profile.schedules.create!(
            duration_hours: duration,
            reference_date: reference_date,
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
