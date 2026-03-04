# frozen_string_literal: true

class TextInlineInput < SimpleForm::Inputs::StringInput
  def input(_wrapper_options = nil)
    template.content_tag(:div, data: { controller: 'inline-text-input' }) do
      template.concat label_part
      template.concat(options[:edit_mode] ? form_part : ''.html_safe)
    end
  end

  def label(_wrapper_options = nil)
    ''
  end

  private

  def form_part
    template.content_tag(:div, wrapper_options) do
      template.concat @builder.text_field(attribute_name, input_options)
      template.concat submit_button
      template.concat cancel_link
    end
  end

  def label_part
    template.content_tag(:span, label_options) do
      template.concat label_options[:prefix] if label_options[:prefix].present?
      template.concat label_part_value
      template.concat edit_action_link
      template.concat label_options[:postfix] if label_options[:postfix].present?
    end
  end

  def label_part_value
    attr_name = edit_enabled? ? "#{attribute_name}_in_database" : attribute_name
    object.public_send(attr_name).to_s
  end

  def edit_action_link
    options[:edit_mode] ? edit_link : ''.html_safe
  end

  def edit_link
    edit_options = html_options_for(:edit, [])
    edit_icon = template.icon('pencil-square', **edit_options)
    template.link_to(edit_icon, '#', data: { action: 'click->inline-text-input#toggle:prevent' })
  end

  def submit_button
    accept_icon = template.icon('check', class: 'w-4 h-4')
    template.content_tag(:button, accept_icon, type: 'submit')
  end

  def cancel_link
    cancel_icon = template.icon('x-mark', class: 'w-4 h-4')
    cancel_options = { class: 'inline-cancel', data: { action: 'click->inline-text-input#toggle:prevent' } }
    template.button_tag(cancel_icon, cancel_options)
  end

  def label_options
    options = label_html_options
    options[:class] = template.class_names(options[:class], 'inline-group', hidden: edit_enabled?)
    options[:data] = { inline_text_input_target: 'label' }
    options
  end

  def input_options
    options = input_html_options
    options[:class] = template.class_names(options[:class], 'text_input')
    options
  end

  def wrapper_options
    visibility = edit_enabled? ? '' : 'hidden'
    wrapper_options = html_options_for(:wrapper, [visibility, 'inline-group'])
    wrapper_options[:data] = { inline_text_input_target: 'form' }
    wrapper_options
  end

  def edit_enabled?
    return false unless options[:edit_mode]

    object.errors[attribute_name.to_sym].present?
  end
end
