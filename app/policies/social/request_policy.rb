# frozen_string_literal: true

module Social
  class RequestPolicy < ApplicationPolicy
    def vote?
      record.social_event.profiles.exists?(user_id: user.id)
    end
  end
end
