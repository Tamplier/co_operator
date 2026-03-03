# frozen_string_literal: true

module Avo
  class Resources::SocialReview < Avo::BaseResource
    # self.includes = []
    # self.attachments = []
    self.model_class = ::Social::Review
    # self.search = {
    #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
    # }

    def fields
      field :id, as: :id
      field :author, as: :belongs_to
      field :target, as: :belongs_to
      field :text, as: :text
      field :rating, as: :number
    end
  end
end
