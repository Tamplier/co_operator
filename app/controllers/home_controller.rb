# frozen_string_literal: true

class HomeController < ApplicationController
  def show; end

  def top_games
    @games = ::Games::TopQuery.call
  end

  def next_events; end
  def top_profiles; end
end
