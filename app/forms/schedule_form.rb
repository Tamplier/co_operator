# frozen_string_literal: true

class ScheduleForm < ApplicationForm
  attribute :start_time, :string
  attribute :reference_date, :string
  attribute :duration_hours, :integer
  attribute :duration_minutes, :integer
  attribute :days, default: []
  attribute :recurring, :boolean, default: true
  attribute :active, :boolean, default: true

  attr_reader :schedule

  delegate :id, :persisted?, to: :schedule

  validates :start_time, presence: true
  validate :duration_must_be_positive

  def initialize(schedule, params = nil)
    @schedule = schedule
    super(params || attributes_from_schedule)
  end

  def save
    return false unless valid?

    schedule.assign_attributes(
      duration: duration,
      reference_date: reference_datetime,
      recurrence_rule: recurrence_rule,
      active: active
    )

    schedule.save
  end

  private

  def duration
    duration_hours.to_i.hours + duration_minutes.to_i.minutes
  end

  def reference_datetime
    Time.zone.parse("#{reference_date} #{start_time}")
  end

  def recurrence_rule
    return unless recurring

    rule = IceCube::Rule.weekly
    rule = rule.day(*days.map(&:to_sym)) if days.present?
    rule
  end

  def attributes_from_schedule
    return {} unless persisted?

    hours = schedule.duration.seconds.in_hours.to_i
    minutes = (schedule.duration.seconds - hours.hours).in_minutes.to_i
    {
      duration_hours: hours,
      duration_minutes: minutes,
      start_time: schedule.reference_date.in_time_zone(Time.zone)&.strftime('%H:%M'),
      days: calculate_days,
      recurring: schedule.recurrence_rule.present?
    }
  end

  def calculate_days
    return [] unless schedule.recurrence_rule.present?

    validations = schedule.recurrence_rule.validations
    days = validations.[](:day)&.map(&:day)
    return [] if days.blank?

    Date::DAYNAMES.values_at(*days).map(&:downcase)
  end

  # Validations

  def duration_must_be_positive
    return if duration.positive?

    errors.add(:duration_hours, :must_be_positive)
    errors.add(:duration_minutes, :must_be_positive)
  end
end
