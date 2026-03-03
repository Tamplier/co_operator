# frozen_string_literal: true

module Avo
  class Resources::SocialEventProfile < Avo::BaseResource
    self.visible_on_sidebar = false
    # self.includes = []
    # self.attachments = []
    self.model_class = ::Social::EventProfile
    # self.search = {
    #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
    # }

    def fields
      field :id, as: :id
      field :social_event, as: :belongs_to
      field :account_profile, as: :belongs_to
    end
  end
end
