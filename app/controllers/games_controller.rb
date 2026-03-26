# frozen_string_literal: true

class GamesController < ApplicationController
  def index; end

  def show
    @game = Game.find(params[:id])
  end

  def search
    query = params[:query]
    return unless query.present?

    games = Game.search_by_title(query)
    render json: games, only: %i[id title]
  end

  def search_modal
    @game_presenters = Games::SearchService.call(
      query: params[:query],
      context: :search_modal,
      profile: current_user&.account_profile
    ).result
  end
end
