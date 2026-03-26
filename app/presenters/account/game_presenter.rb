# frozen_string_literal: true

module Account
  class GamePresenter < ApplicationPresenter
    ACTION_DATA = {
      search_dropdown: {},
      search_modal: { turbo_frame: '_top' },
      add_game_modal: { turbo_stream: true }
    }.freeze

    attr_reader :game, :context, :profile

    delegate_missing_to :@game

    def initialize(game, context:, profile:)
      super()
      @game = game
      @context = context
      @profile = profile
    end

    def dom_id(prefix = '')
      "#{prefix}#{ActionView::RecordIdentifier.dom_id(game)}"
    end

    def action_icon
      game_action[:icon]
    end

    def action_url
      game_action[:url]
    end

    def action_method
      game_action[:method]
    end

    def action_params
      game_action[:params]
    end

    def action_data
      ACTION_DATA[context]
    end

    private

    def profile_game_ids
      @profile_game_ids ||= profile&.games&.pluck(:game_id)&.to_set # rubocop:disable Style/SafeNavigationChainLength
    end

    def game_action
      return {} if context == :search_dropdown
      return { icon: 'chevron-right', url: game_path(game), method: :get } if context == :search_modal

      if profile_game_ids.include?(game.id)
        { icon: 'trash', url: account_profile_my_game_path(game), method: :delete, params: { id: game.id } }
      else
        { icon: 'plus', url: account_profile_my_games_path, method: :puts, params: { id: game.id } }
      end
    end
  end
end
