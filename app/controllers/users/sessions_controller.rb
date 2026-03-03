# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    # before_action :configure_sign_in_params, only: [:create]

    # def new
    #   super
    # end

    def new
      super do |resource|
        message = flash[:alert]
        resource.instance_variable_set(:@form_notice, flash[:notice])
        flash.delete(:alert)
        flash.delete(:notice)
        resource.errors.add(:base, message) if message.present?
      end
    end

    # POST /resource/sign_in
    # def create
    #   super
    # end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
  end
end
