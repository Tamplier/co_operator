# frozen_string_literal: true

module Avo
  class Resources::Schedule < Avo::BaseResource
    # self.includes = []
    # self.attachments = []
    # self.search = {
    #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
    # }

    def fields
      field :id, as: :id
      field :owner, as: :belongs_to
      field :recurrence_rule, as: :text
      field :reference_date, as: :date_time
      field :start_time, as: :date_time
      field :end_time, as: :date_time
      field :active, as: :boolean
    end
  end
end
