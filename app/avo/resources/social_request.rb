# frozen_string_literal: true

module Avo
  class Resources::SocialRequest < Avo::BaseResource
    # self.includes = []
    # self.attachments = []
    self.model_class = ::Social::Request
    # self.search = {
    #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
    # }

    def fields
      field :id, as: :id
      field :request_type, as: :text
      field :target_profile, as: :belongs_to
      field :social_event, as: :belongs_to
      field :approved, as: :boolean
    end
  end
end
