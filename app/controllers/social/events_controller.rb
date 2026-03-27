# frozen_string_literal: true

module Social
  class EventsController < ApplicationController
    before_action :authenticate_user!, except: %i[index]
    before_action :authorize_profile, except: %i[index]

    def index; end

    def new
      @form = EventForm.new(Event.new)
    end

    def create
      @event = Event.new
      @event.profiles << current_profile
      @form = EventForm.new(@event, permitted_params)
      if @form.save
        render turbo_stream: [
          turbo_stream.update(:modal, ''),
          turbo_stream.replace(:sidebar_events, partial: 'shared/sidebar/events')
        ]
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def authorize_profile
      @profile_presenter = Account::ProfilePresenter.new(current_profile)
      authorize current_profile, :update?
    end

    def permitted_params
      params.expect(social_event: %i[game_id language_id start_date duration_hours duration_minutes max_players])
    end
  end
end
