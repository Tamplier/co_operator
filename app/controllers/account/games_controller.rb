# frozen_string_literal: true

module Account
  class GamesController < ApplicationController
    SINGLE_RESULT_PARTIAL = 'games/shared/search_result_game'
    before_action :set_profile, except: [:index]
    before_action :set_game, only: %i[add remove]
    before_action :authenticate_user!, except: %i[index find]

    def index
      @profile = Profile.friendly.find(params[:profile_id])
      @edit_mode = policy(@profile).update?
      @pagination, @games = paginate(@profile.games.order('account_games.created_at asc'))
    end

    def add
      @profile.games << @game unless @profile.games.exists?(@game.id)
      @edit_mode = true
      render turbo_stream: [
        turbo_stream.update(@presenter.dom_id('search_'), html: render_single_result(@presenter, 'search_')),
        turbo_stream.append(:games_added_list, html: render_single_result(@presenter, '')),
        turbo_stream.action(:reload_frame, 'my_games_list')
      ]
    end

    def remove
      @profile.account_games.find_by(game: @game).destroy
      @edit_mode = true
      render turbo_stream: [
        turbo_stream.update(@presenter.dom_id('search_'), html: render_single_result(@presenter, 'search_')),
        turbo_stream.remove(@presenter.dom_id),
        turbo_stream.action(:reload_frame, 'my_games_list')
      ]
    end

    def find
      query = params[:query]
      return if query.blank?

      @game_presenters = ::Game.search_by_title(query).map { build_presenter(it) }
    end

    private

    def build_presenter(game)
      Account::GamePresenter.new(game, context: :add_game_modal, profile: current_user&.account_profile)
    end

    def render_single_result(presenter, prefix)
      render_to_string(partial: SINGLE_RESULT_PARTIAL, locals: { game_presenter: presenter, id_prefix: prefix })
    end

    def set_game
      @game = ::Game.find(params[:id])
      @presenter = build_presenter(@game)
    end

    def set_profile
      @profile = current_user.account_profile
    end
  end
end
