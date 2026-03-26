# frozen_string_literal: true

class GamesController < ApplicationController
  def index; end

  def show
    @game = Game.find(params[:id])
  end

  def search
    @game_presenters = Games::SearchService.call(
      query: params[:query],
      context: :search_dropdown,
      profile: current_user&.account_profile
    ).result

    render body: JSON.generate(
      @game_presenters.map do |presenter|
        {
          id: presenter.id,
          title: presenter.title,
          html: presenter.html_search_row
        }
      end
    ), content_type: 'application/json'
  end

  def search_modal
    @game_presenters = Games::SearchService.call(
      query: params[:query],
      context: :search_modal,
      profile: current_user&.account_profile
    ).result
  end
end
