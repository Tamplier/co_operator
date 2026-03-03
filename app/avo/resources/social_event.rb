# frozen_string_literal: true

module Avo
  class Resources::SocialEvent < Avo::BaseResource
    # self.includes = []
    # self.attachments = []
    self.model_class = ::Social::Event
    # self.search = {
    #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
    # }

    def fields
      field :id, as: :id
      field :language, as: :belongs_to
      field :game, as: :belongs_to
      field :name, as: :text
      field :max_players, as: :number
      field :start_date, as: :date_time
    end
  end
end
