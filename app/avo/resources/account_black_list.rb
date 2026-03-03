# frozen_string_literal: true

module Avo
  class Resources::AccountBlackList < Avo::BaseResource
    self.visible_on_sidebar = false
    # self.includes = []
    # self.attachments = []
    self.model_class = ::Account::BlackList
    # self.search = {
    #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
    # }

    def fields
      field :id, as: :id
      field :requester, as: :belongs_to
      field :target, as: :belongs_to
    end
  end
end
