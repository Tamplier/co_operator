# frozen_string_literal: true

module Account
  class ProfilesController < ApplicationController
    before_action :authenticate_user!, except: [:show]
    before_action :set_profile, except: [:show]

    def show
      @profile = Account::Profile.friendly.find(params[:id])
      @edit_mode = policy(@profile).update?
    end

    def update_email
      common_update do
        flash.now[:notice] = I18n.t('devise.registrations.update_needs_confirmation')
        respond_to do |format|
          format.html { redirect_to me_account_profile_path }
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.update(request.headers['Turbo-Frame'], partial: 'account/profiles/base/email'),
              turbo_stream.update(:flash, partial: 'shared/flash')
            ]
          end
        end
      end
    end

    def update_base
      common_update
    end

    def me
      render :show
    end

    private

    def common_update(partial = 'account/profiles/base_info')
      authorize @profile

      @edit_mode = true # 'authorize' literally checks 'update?'
      result = @profile.update(profile_params)
      if result && block_given?
        yield
      else
        render partial: partial, status: result ? :ok : :unprocessable_content
      end
    end

    def set_profile
      @profile = current_user.account_profile
      authorize @profile, :update?
      @edit_mode = true
    end

    def profile_params
      params.expect(account_profile: [:name, :slug, :avatar, :remove_avatar, :timezone, { user_attributes: [:email] }])
    end
  end
end
