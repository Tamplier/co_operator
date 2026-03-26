# frozen_string_literal: true

module Account
  class ProfilePresenter < ApplicationPresenter
    attr_reader :profile

    delegate_missing_to :@profile

    def initialize(profile)
      super()
      @profile = profile
    end

    def games_for_select(context)
      games_presenters(context).map do |presenter|
        search_card = presenter.html_search_row

        [presenter.title, presenter.id, { 'data-html': search_card }]
      end
    end

    def games_presenters(context)
      @games_presenters ||= {}
      @games_presenters[context] ||= games.map do |g|
        ::Account::GamePresenter.new(g, context: context, profile: profile)
      end
    end
  end
end
