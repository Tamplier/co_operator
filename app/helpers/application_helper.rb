# frozen_string_literal: true

module ApplicationHelper
  def inline_field_frame(record, field, url = nil, &)
    data = { controller: 'submit' }

    turbo_frame_tag dom_id(record, field) do
      simple_form_for(record, data: data, url: url) do |f|
        capture(f, &)
      end
    end
  end
end
