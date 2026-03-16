# frozen_string_literal: true

module Account
  class CalendarPresenter < ApplicationPresenter
    attr_reader :profile, :today, :offset

    def initialize(profile, offset)
      super()
      @profile = profile
      @today = Time.zone.today
      @offset = offset.clamp(0, 1)
    end

    def weeks
      @weeks ||= begin
        dates = (start_date..end_date).to_a
        leading  = Array.new((start_date.wday + 6) % 7)
        trailing = Array.new((7 - ((leading.size + dates.size) % 7)) % 7)

        calendar_days = leading + dates + trailing
        calendar_days.each_slice(7)
      end
    end

    def header_to_display
      base_date.strftime('%B %Y')
    end

    def date_classes(date)
      occupied = any_occurences?(date)
      bg = occupied ? 'occupied' : 'bg-transparent'
      border = date == today ? 'today' : ''

      [bg, border].join(' ')
    end

    def any_occurences?(date)
      occurrences_ranges.any? { |range| range.cover?(date) }
    end

    def prev_month_params
      if prev_offset.present?
        [calendar_account_profile_schedules_path(@profile, offset: prev_offset), { class: 'nav-link' }]
      else
        ['#', { class: 'nav-link disabled' }]
      end
    end

    def next_month_params
      if next_offset.present?
        [calendar_account_profile_schedules_path(@profile, offset: next_offset), { class: 'nav-link' }]
      else
        ['#', { class: 'nav-link disabled' }]
      end
    end

    private

    def prev_offset
      offset - 1 if offset.positive?
    end

    def next_offset
      offset + 1 if offset < 1
    end

    def base_date
      @base_date ||= today.beginning_of_month + offset.months
    end

    def start_date
      @start_date ||= base_date.beginning_of_month
    end

    def end_date
      @end_date ||= base_date.end_of_month
    end

    def occurrences_ranges
      @occurrences_ranges ||= profile.schedule_occurrences
                                     .pluck(:start_at, :end_at)
                                     .map { |s, e| s.to_date..e.to_date }
                                     .uniq
    end
  end
end
