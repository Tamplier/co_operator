# frozen_string_literal: true

module Avo
  class Resources::AccountScheduledGame < Avo::BaseResource
    self.visible_on_sidebar = false
    # self.includes = []
    # self.attachments = []
    self.model_class = ::Account::ScheduledGame
    # self.search = {
    #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
    # }

    def fields
      field :id, as: :id
      field :schedule, as: :belongs_to
      field :game, as: :belongs_to
    end
  end
end
