# frozen_string_literal: true

module Avo
  class Resources::AccountFriendRequest < Avo::BaseResource
    self.visible_on_sidebar = false
    # self.includes = []
    # self.attachments = []
    self.model_class = ::Account::FriendRequest
    # self.search = {
    #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
    # }

    def fields
      field :id, as: :id
      field :requester, as: :belongs_to
      field :recipient, as: :belongs_to
      field :status, as: :number
    end
  end
end
