# frozen_string_literal: true

module Account
  class GamesController < ApplicationController
    SINGLE_RESULT_PARTIAL = 'games/shared/search_result_game'
    before_action :set_profile
    before_action :set_game, except: [:find]
    before_action :authenticate_user!, except: [:find]

    def add
      @edit_mode = true
      @profile.games << @game
      render turbo_stream: [
        turbo_stream.update(@presenter.dom_id('search_'), html: render_single_result(@presenter, 'search_')),
        turbo_stream.append(:games_added_list, html: render_single_result(@presenter, '')),
        turbo_stream.update('my_games_list', partial: 'account/profiles/games_info')
      ]
    end

    def remove
      @edit_mode = true
      @profile.account_games.find_by(game: @game).destroy
      render turbo_stream: [
        turbo_stream.update(@presenter.dom_id('search_'), html: render_single_result(@presenter, 'search_')),
        turbo_stream.remove(@presenter.dom_id),
        turbo_stream.update('my_games_list', partial: 'account/profiles/games_info')
      ]
    end

    def find
      query = params[:query]
      return if query.blank?

      @game_presenters = ::Game.search_by_title(query).map do |game|
        ::Account::GamePresenter.new(game, context: :add_game_modal, profile: current_user&.account_profile)
      end
    end

    private

    def render_single_result(presenter, prefix)
      render_to_string(partial: SINGLE_RESULT_PARTIAL, locals: { game_presenter: presenter, id_prefix: prefix })
    end

    def set_game
      @game = ::Game.find(params[:id])
      @presenter = ::Account::GamePresenter.new(@game, context: :add_game_modal, profile: current_user&.account_profile)
    end

    def set_profile
      @profile = current_user.account_profile
    end
  end
end
