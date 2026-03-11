# frozen_string_literal: true

module Account
  class SchedulesController < ApplicationController
    before_action :set_profile, except: [:index]
    before_action :authenticate_user!, except: %i[index]

    def index
      @profile = Profile.friendly.find(params[:profile_id])
      @edit_mode = policy(@profile).update?
      @schedule_presenters = @profile.schedules.map { SchedulePresenter.new(it) }
    end

    def new; end

    def create; end

    def update; end

    def destroy; end

    private

    def set_profile
      @profile = current_user.account_profile
    end
  end
end
