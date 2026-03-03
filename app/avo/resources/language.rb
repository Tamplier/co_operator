# frozen_string_literal: true

module Avo
  class Resources::Language < Avo::BaseResource
    # self.includes = []
    # self.attachments = []
    # self.search = {
    #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
    # }

    def fields
      field :id, as: :id
      field :code, as: :text
      field :name, as: :text
    end
  end
end
