# frozen_string_literal: true

module Avo
  class Resources::SocialMessage < Avo::BaseResource
    # self.includes = []
    # self.attachments = []
    self.model_class = ::Social::Message
    # self.search = {
    #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
    # }

    def fields
      field :id, as: :id
      field :author, as: :belongs_to
      field :recipient, as: :belongs_to
      field :text, as: :text
    end
  end
end
