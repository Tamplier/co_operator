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
class Schedule < ApplicationRecord
  OCCURRENCES_GENERATOR_PERIOD = 2.months
  OCCURRENCES_GENERATOR_OFFSET = 1.minute

  attribute :recurrence_rule, IceCubeRuleType.new

  belongs_to :owner, polymorphic: true
  has_many :schedule_occurrences, dependent: :destroy

  after_save :update_occurrences

  def schedule_object
    @schedule_object ||= begin
      schedule = IceCube::Schedule.new(reference_date, duration: duration)
      schedule.add_recurrence_rule(recurrence_rule) if recurrence_rule

      schedule
    end
  end

  delegate_missing_to :schedule_object

  def generation_start_date
    @generation_start_date ||= Time.current.beginning_of_day - OCCURRENCES_GENERATOR_OFFSET
  end

  def generation_end_date
    @generation_end_date ||= generation_start_date + OCCURRENCES_GENERATOR_PERIOD
  end

  private

  def update_occurrences
    return unless active

    schedule_occurrences.destroy_all
    occurrences = occurrences_between(generation_start_date, generation_end_date)

    occurrences_data = occurrences.map do |o|
      {
        updated_at: Time.current,
        created_at: Time.current,
        start_at: o.start_time.to_datetime,
        end_at: o.end_time.to_datetime
      }
    end
    schedule_occurrences.insert_all!(occurrences_data)
  end
end
