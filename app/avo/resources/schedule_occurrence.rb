# frozen_string_literal: true

module Avo
  class Resources::ScheduleOccurrence < Avo::BaseResource
    self.visible_on_sidebar = false
    # self.includes = []
    # self.attachments = []
    # self.search = {
    #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
    # }

    def fields
      field :id, as: :id
      field :schedule, as: :belongs_to
      field :start_at, as: :date_time
      field :end_at, as: :date_time
    end
  end
end
