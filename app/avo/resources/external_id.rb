# frozen_string_literal: true

module Avo
  class Resources::ExternalId < Avo::BaseResource
    self.visible_on_sidebar = false
    # self.includes = []
    # self.attachments = []
    # self.search = {
    #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
    # }

    def fields
      field :id, as: :id
      field :external_id, as: :text
      field :store, as: :belongs_to
      field :owner,
            as: :belongs_to,
            polymorphic_as: :owner,
            types: [Game]
    end
  end
end
