# frozen_string_literal: true

module Steam
  class UpdateListService < ApplicationService
    LIST_LIMIT = [5_000, ::Steam::Client::APP_LIST_LIMIT].min

    def initialize(limit: LIST_LIMIT)
      super()
      @limit = limit
      @store = Store.steam
    end

    def call
      client = ::Steam::Client.new
      last_appid = ExternalId.steam.order(created_at: :desc).pick(:external_id)
      processed_games = 0

      loop do
        response = client.app_list(limit: @limit, last_appid: last_appid).with_indifferent_access
        app_list = response.dig('response', 'apps')
        last_appid = response.dig('response', 'last_appid')
        more_results = response.dig('response', 'have_more_results')
        break if app_list.blank?

        process_list(app_list)
        processed_games += app_list.length
        Rails.logger.info("Steam::UpdateListService processed #{processed_games} records")

        break if app_list.length < @limit || !more_results
      end

      success
    end

    private

    def process_list(app_list)
      app_list.each_slice(1_000) do |batch|
        games = batch.map do |p|
          game = Game.new(title: p['name'], last_modified: p['last_modified'])
          game.external_ids.build(store: @store, external_id: p['appid'])
          game
        end
        Game.import(games, recursive: true, validate: false)
      end
    end
  end
end
