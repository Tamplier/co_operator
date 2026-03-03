# frozen_string_literal: true

module Avo
  class Resources::Store < Avo::BaseResource
    # self.includes = []
    # self.attachments = []
    # self.search = {
    #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
    # }

    def fields
      field :id, as: :id
      field :title, as: :text, required: true
      field :game_link_pattern, as: :text, required: true
      field :profile_link_pattern, as: :text, required: true
      field :logo, as: :file, is_image: true, format_using: lambda {
        if view.index?
          value.variant(:thumb).processed.image
        else
          value.variant(:medium).processed.image
        end
      }
    end
  end
end
