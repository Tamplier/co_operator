# frozen_string_literal: true

class ImageUploadInput < SimpleForm::Inputs::FileInput
  def input(_wrapper_options)
    image = object.public_send(attribute_name).variant(options[:variant])
    template.content_tag(:div, w_options) do
      template.concat empty_image if image.blank?
      template.concat preview(image) if image.present?
      template.concat upload_button
      template.concat super(input_options)
    end
  end

  def label(_wrapper_options)
    ''
  end

  private

  # Elements

  def preview(image)
    template.content_tag(:div, 'relative') do
      template.concat template.image_tag(image.processed.image, class: 'image-preview')
      template.concat delete_button
    end
  end

  def delete_button
    template.button_tag(delete_button_options) do
      template.icon('trash')
    end
  end

  def empty_image
    template.content_tag(:div, class: 'image-preview image-empty-bg') do
      template.icon('user', class: 'image-empty-icon')
    end
  end

  def upload_button
    template.button_tag(upload_button_options) do
      template.icon('camera', class: 'image-upload-button-icon')
    end
  end

  # Options

  def w_options
    html_options_for(:wrapper, [])
    # w_options[:data] = { data: { controller: 'image-upload' } }
  end

  def input_options
    input_options = input_html_options
    input_options[:class] = 'hidden'
    input_options[:data] = { data: { image_upload_target: 'input', action: 'change->image-upload#upload' } }
  end

  def upload_button_options
    button_options = { class: 'image-upload-button', type: :button }
    button_options[:data] = {
      image_upload_target: 'button spinner',
      action: 'click->image-upload#open dragover->image-upload#dragover drop->image-upload#drop ' \
              'dragenter->image-upload#dragenter dragleave->image-upload#dragleave'
    }
    button_options
  end

  def delete_button_options
    button_options = { class: 'delete_button', type: :button }
    button_options[:data] = {
      'image-upload-target': 'delete_button',
      action: 'click->image-upload#deleteFile'
    }
    button_options
  end
end
