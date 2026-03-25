# frozen_string_literal: true

module Games
  class TopQuery
    LIMIT = 6

    def self.call
      Game.joins(:account_games)
          .select('games.*, COUNT(account_games.id) AS mentions_count')
          .group(:id)
          .order('mentions_count DESC')
          .limit(LIMIT)
    end
  end
end
