# frozen_string_literal: true

module Steam
  class Client
    API_URL = 'https://api.steampowered.com'
    STORE_URL = 'https://store.steampowered.com'
    APP_LIST_LIMIT = 50_000 # defined by steam api
    DEFAULT_LANGUAGE = 'en'

    def initialize(api_key: ENV.fetch('STEAM_API_KEY'))
      @api_key = api_key
    end

    def app_list(limit: APP_LIST_LIMIT, last_appid: nil)
      api_get('/IStoreService/GetAppList/v1/', max_results: limit, last_appid: last_appid)
    end

    def app_info(app_ids:, language: DEFAULT_LANGUAGE)
      store_get('/api/appdetails', appids: Array(app_ids).join(','), l: language)
    end

    private

    def api_get(path, params = {})
      api_connection.get(path, params.compact.merge(key: @api_key)).body
    end

    def store_get(path, params = {})
      store_connection.get(path, params.compact).body
    end

    def api_connection
      @api_connection ||= build_connection(API_URL)
    end

    def store_connection
      @store_connection ||= build_connection(STORE_URL)
    end

    def build_connection(url)
      Faraday.new(url: url) do |f|
        f.request  :url_encoded
        f.response :json
        f.response :raise_error
        f.response :logger if Rails.env.development?
        f.options.timeout = 10
        f.options.open_timeout = 5
      end
    end
  end
end
