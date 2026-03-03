# frozen_string_literal: true

module Avo
  class Resources::AccountProfile < Avo::BaseResource
    # self.includes = []
    # self.attachments = []
    self.model_class = ::Account::Profile
    # self.search = {
    #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
    # }

    def fields
      field :id, as: :id
      field :name, as: :text
      field :rating, as: :number
      field :timezone, as: :text
    end
  end
end
