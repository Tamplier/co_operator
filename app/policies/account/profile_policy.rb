# frozen_string_literal: true

module Account
  class ProfilePolicy < ApplicationPolicy
    def update?
      user&.id == record.user.id
    end

    def resend_email_confirmation?
      update? && record.user.reload.unconfirmed_email.present?
    end

    alias update_base? update?
    alias update_email? update?
  end
end
