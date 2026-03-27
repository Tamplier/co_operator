# frozen_string_literal: true

module Account
  class GamesController < ApplicationController
    SINGLE_RESULT_PARTIAL = 'games/shared/search_result_game'
    before_action :authenticate_user!, except: %i[index]
    before_action :authorize_profile, except: [:index]
    before_action :set_game, only: %i[create destroy]

    def index
      @profile = Profile.friendly.find(params[:profile_id])
      @edit_mode = policy(@profile).update?
      @pagination, @games = paginate(@profile.games.order('account_games.created_at asc'))
    end

    def new
      @game_presenters = Games::SearchService.call(
        query: params[:query],
        context: :add_game_modal,
        profile: current_profile
      ).result
    end

    def create
      current_profile.games << @game unless current_profile.games.exists?(@game.id)
      @edit_mode = true
      render turbo_stream: [
        turbo_stream.update(@presenter.dom_id('search_'), html: render_single_result(@presenter, 'search_')),
        turbo_stream.append(:games_added_list, html: render_single_result(@presenter, '')),
        turbo_stream.action(:reload_frame, 'my_games_list')
      ]
    end

    def destroy
      current_profile.account_games.find_by(game: @game).destroy
      @edit_mode = true
      render turbo_stream: [
        turbo_stream.update(@presenter.dom_id('search_'), html: render_single_result(@presenter, 'search_')),
        turbo_stream.remove(@presenter.dom_id),
        turbo_stream.action(:reload_frame, 'my_games_list')
      ]
    end

    private

    def render_single_result(presenter, prefix)
      render_to_string(partial: SINGLE_RESULT_PARTIAL, locals: { game_presenter: presenter, id_prefix: prefix })
    end

    def set_game
      @game = ::Game.find(params[:id])
      @presenter = build_presenter(@game)
    end

    def authorize_profile
      authorize current_profile, :update?
    end
  end
end
