# frozen_string_literal: true

module Social
  class FinalizeRequestService < ApplicationService
    def initialize(request)
      super()
      @request = request
    end

    def call
      return unless @request.accepted?

      case @request.request_type
      when 'join_event'
        join_target!
      when 'kick_event'
        kick_target!
      end
      success(@request)
    end

    private

    def join_target!
      profile = @request.target_profile
      event = @request.social_event
      event.event_profiles.create!(account_profile: profile)
    end

    def kick_target!
      profile = @request.target_profile
      event = @request.social_event
      event.event_profiles.find_by(account_profile: profile).destroy
    end
  end
end
