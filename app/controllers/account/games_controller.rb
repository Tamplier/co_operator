# frozen_string_literal: true

module Account
  class GamesController < ApplicationController
    SINGLE_RESULT_PARTIAL = 'games/shared/search_result_game'
    before_action :authenticate_user!, except: %i[index new]
    before_action :set_profile, except: [:index]
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
        profile: current_user&.account_profile
      ).result
    end

    def create
      @profile.games << @game unless @profile.games.exists?(@game.id)
      @edit_mode = true
      render turbo_stream: [
        turbo_stream.update(@presenter.dom_id('search_'), html: render_single_result(@presenter, 'search_')),
        turbo_stream.append(:games_added_list, html: render_single_result(@presenter, '')),
        turbo_stream.action(:reload_frame, 'my_games_list')
      ]
    end

    def destroy
      @profile.account_games.find_by(game: @game).destroy
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

    def set_profile
      @profile = current_user.account_profile
      authorize @profile, :update?
    end
  end
end
