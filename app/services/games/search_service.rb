# frozen_string_literal: true

module Games
  class SearchService < ApplicationService
    attr_reader :query, :context, :profile

    def initialize(query:, context:, profile:)
      super()
      @query = query
      @context = context
      @profile = profile
    end

    def call
      return success unless query.present?

      presenters = Game.search_by_title(query).map do |game|
        ::Account::GamePresenter.new(
          game,
          context: context,
          profile: profile
        )
      end

      success(presenters)
    end
  end
end
