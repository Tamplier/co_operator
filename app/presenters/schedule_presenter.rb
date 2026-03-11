# frozen_string_literal: true

class SchedulePresenter < ApplicationPresenter
  attr_reader :schedule, :first_occurence

  delegate_missing_to :@schedule

  def initialize(schedule)
    super()
    @schedule = schedule
    @first_occurence = schedule.first
  end

  def show?
    first_occurence.present?
  end

  def display_time_range
    "#{format_time(first_occurence.start_time)} – #{format_time(first_occurence.end_time)}"
  end

  def display_days
    days = if schedule.recurrence_rule.present?
             formatted_days
           else
             format_date(first_occurence.start_time)
           end
    Array(days)
  end

  private

  def format_date(date)
    "#{localized_day_of_week(date.wday)} (#{date.strftime('%b %d')})"
  end

  def format_time(time)
    time.strftime('%H:%M')
  end

  def formatted_days
    rule = schedule.recurrence_rules.first
    days = rule.validations[:day]

    if days
      days.map { |d| localized_day_of_week(d.day) }
    else
      I18n.t('date.dayly')
    end
  end

  def localized_day_of_week(day)
    I18n.t('date.abbr_day_names')[day]
  end
end
