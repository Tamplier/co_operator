# frozen_string_literal: true

module Account
  class SchedulesController < ApplicationController
    before_action :authenticate_user!, except: %i[index]
    before_action :set_profile, except: [:index]
    before_action :set_schedule, only: %i[edit update destroy]

    def index
      @profile = Profile.friendly.find(params[:profile_id])
      @edit_mode = policy(@profile).update?
      @schedule_presenters = @profile.schedules.map { SchedulePresenter.new(it) }
    end

    def new
      @schedule = @profile.schedules.build
      build_form
    end

    def create
      @schedule = @profile.schedules.build
      build_form(permitted_params)
      if @form.save
        render turbo_stream: [
          turbo_stream.update(:modal, ''),
          turbo_stream.append(:schedules_container, partial: 'account/schedules/schedule_card',
                                                    locals: { presenter: SchedulePresenter.new(@schedule) })
        ]
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      build_form
      render :new
    end

    def update
      build_form(permitted_params)
      if @form.save
        render turbo_stream: [
          turbo_stream.update(:modal, ''),
          turbo_stream.replace(helpers.dom_id(@schedule), partial: 'account/schedules/schedule_card',
                                                          locals: { presenter: SchedulePresenter.new(@schedule) })
        ]
      else
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      @schedule.destroy
      render turbo_stream: turbo_stream.remove(helpers.dom_id(@schedule))
    end

    private

    def set_profile
      @profile = current_user.account_profile
      authorize @profile, :update?
      @edit_mode = true
    end

    def set_schedule
      @schedule = ::Schedule.find(params[:id])
    end

    def build_form(params = nil)
      @form = ScheduleForm.new(@schedule, params)
    end

    def permitted_params
      permitted = params.expect(
        schedule: [:start_time, :duration_hours, :duration_minutes,
                   :reference_date, :recurring, :active, { days: [] }]
      )
      permitted[:days]&.compact_blank!

      permitted
    end
  end
end
