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
  helper_method :current_profile

  def turbo_request?
    request.format.turbo_stream? || request.headers['Turbo-Frame'].present?
  end

  def current_profile
    @current_profile ||= current_user&.account_profile
  end

  private

  def set_user_time_zone(&)
    timezone = current_user&.account_profile&.timezone || 'UTC'
    Time.use_zone(timezone, &)
  end
end
