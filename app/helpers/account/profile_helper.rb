# frozen_string_literal: true

module Account
  module ProfileHelper
    def timezone_options
      ActiveSupport::TimeZone.all.map { |tz| ["#{tz.name} (UTC#{tz.formatted_offset})", tz.name] }
    end

    def timezone_to_display(name)
      tz = ActiveSupport::TimeZone.all.find { |tz| tz.name == name }
      "#{tz.name} (UTC#{tz.formatted_offset})"
    end

    def language_options
      Language.all.map { |l| [l.code, l.id] }
    end
  end
end
