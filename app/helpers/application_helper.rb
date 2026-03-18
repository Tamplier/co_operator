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

  def dropdown_with_search(record, field, url, collection)
    submit_data = { controller: 'submit', submit_wrapper_classes_value: '["rounded-md"]' }
    turbo_frame_tag dom_id(record, field) do
      simple_form_for(record, url: url, data: submit_data, html: { class: 'relative' }) do |f|
        concat f.input(field, as: :select,
                              collection: collection,
                              label: false,
                              wrapper_html: { data: { submit_target: 'spinner' } },
                              input_html: { data: { controller: 'dropdown' }, class: 'dropdown' })
      end
    end
  end

  def link_conditional(path, condition, **, &)
    return capture(&) unless condition

    link_to(path, **, &)
  end
end
