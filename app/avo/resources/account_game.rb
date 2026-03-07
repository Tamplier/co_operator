# frozen_string_literal: true

module Avo
  class Resources::AccountGame < Avo::BaseResource
    # self.includes = []
    # self.attachments = []
    self.model_class = ::Account::Game
    # self.search = {
    #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
    # }

    def fields
      field :id, as: :id
      field :account_profile, as: :belongs_to
      field :game, as: :belongs_to
    end
  end
end
