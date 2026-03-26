# frozen_string_literal: true

module Social
  class EventsController < ApplicationController
    before_action :authenticate_user!, except: %i[index]
    before_action :set_profile, except: %i[index]

    def index; end

    def new
      @form = EventForm.new(Event.new)
    end

    def create
      @event = @profile.social_events.build
      @form = EventForm.new(@event, permitted_params)
      if @form.save
        render turbo_stream: turbo_stream.update(:modal, '')
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def set_profile
      @profile = current_user.account_profile
      @profile_presenter = Account::ProfilePresenter.new(@profile)
    end

    def permitted_params
      params.expect(social_event: %i[game_id language_id start_date duration_hours duration_minutes max_players])
    end
  end
end
