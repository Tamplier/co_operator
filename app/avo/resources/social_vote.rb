# frozen_string_literal: true

module Avo
  class Resources::SocialVote < Avo::BaseResource
    self.visible_on_sidebar = false
    # self.includes = []
    # self.attachments = []
    self.model_class = ::Social::Vote
    # self.search = {
    #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
    # }

    def fields
      field :id, as: :id
      field :social_request, as: :belongs_to
      field :account_profile, as: :belongs_to
      field :decision, as: :number
    end
  end
end
