# frozen_string_literal: true

module Avo
  class Resources::Game < Avo::BaseResource
    self.single_includes = %i[external_ids]
    # self.attachments = []
    # self.search = {
    #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
    # }

    def fields
      field :id, as: :id
      field :title, as: :text, required: true
      field :description, as: :textarea, required: true
      field :rating, as: :number
      field :preview, as: :file, is_image: true
      field :external_ids,
            as: :has_many,
            allow_create: true,
            allow_destroy: true
    end
  end
end
