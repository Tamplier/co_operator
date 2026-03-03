# frozen_string_literal: true

module Avo
  class Resources::AccountPrefferedLanguage < Avo::BaseResource
    self.visible_on_sidebar = false
    # self.includes = []
    # self.attachments = []
    self.model_class = ::Account::PrefferedLanguage
    # self.search = {
    #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
    # }

    def fields
      field :id, as: :id
      field :account_profile, as: :belongs_to
      field :language, as: :belongs_to
      field :priority, as: :number
    end
  end
end
