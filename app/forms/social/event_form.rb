# frozen_string_literal: true

module Social
  class EventForm < ApplicationForm
    attribute :game_id, :integer
    attribute :language_id, :integer
    attribute :start_date, :string
    attribute :duration_hours, :integer
    attribute :duration_minutes, :integer
    attribute :max_players, :integer

    attr_reader :event

    delegate :id, :persisted?, to: :event

    validates :game_id, presence: true
    validates :language_id, presence: true

    validate :duration_must_be_positive
    validate :start_date_must_be_in_future
    validate :associations_exist

    def initialize(event, params = nil)
      @event = event
      super(params || attributes_from_event)
    end

    def save
      return false unless valid?

      event.assign_attributes(
        language_id: language_id,
        duration: duration,
        start_date: start_date_parsed,
        game_id: game_id,
        max_players: max_players
      )

      event.save
    end

    private

    def game
      @game ||= ::Game.find_by(id: game_id)
    end

    def language
      @language ||= ::Language.find_by(id: language_id)
    end

    def duration
      duration_hours.to_i.hours + duration_minutes.to_i.minutes
    end

    def start_date_parsed
      return if start_date.blank?

      Time.zone.parse(start_date)&.utc
    end

    def attributes_from_event
      return {} unless persisted?

      hours = event.duration.seconds.in_hours.to_i
      minutes = (event.duration.seconds - event.hours).in_minutes.to_i
      {
        duration_hours: hours,
        duration_minutes: minutes,
        start_date: event.start_date.in_time_zone(Time.zone)&.strftime('%Y-%m-%dT%H:%M'),
        game_id: event.game_id,
        language_id: language_id,
        max_players: event.max_players
      }
    end

    # Validations

    def duration_must_be_positive
      return if duration.positive?

      errors.add(:duration_hours, :must_be_positive) unless duration_hours.positive?
      errors.add(:duration_minutes, :must_be_positive) unless duration_minutes.positive?
    end

    def start_date_must_be_in_future
      if start_date_parsed.blank?
        errors.add(:start_date, :invalid)
      elsif start_date_parsed < Time.current
        errors.add(:start_date, :future_date_restriction)
      end
    end

    def associations_exist
      errors.add(:game_id, :not_found) if game_id.present? && game.nil?
      errors.add(:language_id, :not_found) if language_id.present? && language.nil?
    end
  end
end
