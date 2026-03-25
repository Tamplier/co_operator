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
    query = params[:query]
    return unless query.present?

    @game_presenters = Game.search_by_title(query).map do |game|
      ::Account::GamePresenter.new(game, context: :search_modal, profile: current_user&.account_profile)
    end
  end
end
