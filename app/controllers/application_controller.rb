# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  # default_form_builder AppFormBuilder

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  def turbo_request?
    request.format.turbo_stream? || request.headers['Turbo-Frame'].present?
  end
end
