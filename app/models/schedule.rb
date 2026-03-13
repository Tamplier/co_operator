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

  attribute :start_time, :string
  attribute :recurring, :boolean
  attribute :duration_hours, :integer
  attribute :duration_minutes, :integer
  attribute :days
  attribute :recurrence_rule, IceCubeRuleType.new

  belongs_to :owner, polymorphic: true
  has_many :schedule_occurrences, dependent: :destroy

  validate :duration_must_be_positive

  before_validation :build_from_form
  after_save :update_occurrences

  delegate_missing_to :schedule_object

  def recurring
    super || recurrence_rule.present?
  end

  def start_time
    super || reference_date&.in_time_zone(Time.zone)&.strftime('%H:%M')
  end

  def duration_hours
    return super if super
    return 0 unless duration

    duration.seconds.in_hours.to_i
  end

  def duration_minutes
    return super if super
    return 0 unless duration

    (duration.seconds - duration_hours.hours).in_minutes.to_i
  end

  def days
    super || calculate_days
  end

  def schedule_object
    @schedule_object ||= begin
      localized_reference_date = reference_date&.in_time_zone(Time.zone)
      schedule = IceCube::Schedule.new(localized_reference_date, duration: duration)
      schedule.add_recurrence_rule(recurrence_rule) if recurrence_rule

      schedule
    end
  end

  def generation_start_date
    @generation_start_date ||= Time.current.beginning_of_day - OCCURRENCES_GENERATOR_OFFSET
  end

  def generation_end_date
    @generation_end_date ||= generation_start_date + OCCURRENCES_GENERATOR_PERIOD
  end

  private

  def calculate_days # rubocop:disable Metrics/CyclomaticComplexity
    return [] unless recurring

    validations = recurrence_rule&.validations
    days = validations&.[](:day)&.map(&:day)
    return [] if days.blank?

    Date::DAYNAMES.values_at(*days).map(&:downcase)
  end

  # Validations

  def duration_must_be_positive
    return if duration.positive?

    errors.add(:duration_hours, :must_be_positive) unless duration_hours.positive?
    errors.add(:duration_minutes, :must_be_positive) unless duration_minutes.positive?
  end

  # Callbacks

  def build_from_form
    return if start_time.blank? || (!recurring && reference_date.blank?)

    self.duration = duration_hours.hours + duration_minutes.minutes
    self.reference_date = Time.zone.parse("#{reference_date} #{start_time}")

    build_rrule
  end

  def build_rrule
    return unless recurring

    rule = IceCube::Rule.weekly
    rule = rule.day(*days.map(&:to_sym)) if days.present?
    self.recurrence_rule = rule
  end

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
