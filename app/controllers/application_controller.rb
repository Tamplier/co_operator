# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Paginatable

  # default_form_builder AppFormBuilder

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  around_action :set_user_time_zone, if: :current_user

  def turbo_request?
    request.format.turbo_stream? || request.headers['Turbo-Frame'].present?
  end

  private

  def set_user_time_zone(&)
    Time.use_zone(current_user.account_profile.timezone, &)
  end
end
