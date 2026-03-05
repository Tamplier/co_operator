# frozen_string_literal: true

module Steam
  class UpdateListJob < ApplicationJob
    queue_as :low_priority
    limits_concurrency to: 2, duration: 1.hour
    retry_on Faraday::Error, wait: 6.minutes, attempts: 5

    def perform
      Steam::UpdateListService.call!
    end
  end
end
