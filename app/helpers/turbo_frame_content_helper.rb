# frozen_string_literal: true

module TurboFrameContentHelper
  def turbo_frame_content_for(target, &)
    if controller.turbo_request?
      turbo_frame_tag(target, &)
    else
      content_for(target, capture(&))
    end
  end
end
