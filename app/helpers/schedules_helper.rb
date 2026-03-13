# frozen_string_literal: true

module SchedulesHelper
  def week_days
    @week_days ||= Date::DAYNAMES
                   .zip(I18n.t('date.abbr_day_names'))
                   .rotate(1)
                   .map { |full, abbr| [abbr, full.downcase] }
  end
end
