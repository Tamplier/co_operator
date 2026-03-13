# frozen_string_literal: true

class ToggleInput < SimpleForm::Inputs::Base
  def input(_wrapper_options = nil)
    id = "#{object_name}_#{attribute_name}"

    size = options.delete(:size) || :md
    cls = "peer toggle-base toggle-dot toggle-#{size}"

    custom_label = options.delete(:label) || label_text

    @builder.template.content_tag(:label, class: 'toggle-wrapper') do
      @builder.check_box(attribute_name, input_html_options.merge(class: 'sr-only peer', id: id)) +
        @builder.template.content_tag(:div, '', class: cls) +
        @builder.template.content_tag(:span, custom_label, class: 'toggle-label')
    end
  end

  def label(_wrapper_options = nil)
    ''
  end
end
