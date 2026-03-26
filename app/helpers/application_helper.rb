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

  def dropdown_with_search(record, field, url, collection, **params)
    inline = params[:f].blank?
    stimulus_vals = params[:scontroller_values]&.transform_keys { |k| :"dropdown_#{k}" }
    submit_data = inline ? { controller: 'submit', submit_wrapper_classes_value: '["rounded-md"]' } : {}

    content = lambda do |f|
      f.input(field, as: :select, collection: collection,
                     wrapper_html: { data: { submit_target: 'spinner' } },
                     label_html: { **params[:label_html] },
                     input_html: {
                       class: 'dropdown', multiple: params[:multiple] || false,
                       data: { controller: 'dropdown',
                               **stimulus_vals,
                               dropdown_inline_value: inline,
                               dropdown_placeholder_value: t(".#{field}") }
                     })
    end

    turbo_frame_tag dom_id(record, field) do
      next content.call(params[:f]) if params[:f].present?

      simple_form_for(record, url: url, data: submit_data, html: { class: 'relative' }) { |f| content.call(f) }
    end
  end

  def link_conditional(path, condition, **, &)
    return capture(&) unless condition

    link_to(path, **, &)
  end
end
