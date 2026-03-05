# frozen_string_literal: true

class GamesController < ApplicationController
  def index; end

  def show
    @game = Game.find(params[:id])
  end

  def search_modal
    @games = params[:query].present? ? Game.search_by_title(params[:query]) : nil
  end
end
