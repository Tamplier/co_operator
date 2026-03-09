# frozen_string_literal: true

module Paginatable
  extend ActiveSupport::Concern

  def paginate(scope, per_page: 6)
    page = params.fetch(:page, 1).to_i

    pagination = Pagination.new(scope, page:, per_page:)

    records = pagination.total_pages.positive? ? scope.offset(pagination.offset).limit(per_page) : []

    [pagination, records]
  end
end
