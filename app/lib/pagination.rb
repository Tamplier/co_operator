# frozen_string_literal: true

class Pagination
  attr_reader :page, :per_page, :total_count, :total_pages

  def initialize(scope, page:, per_page:)
    @page = [page.to_i, 1].max
    @per_page = per_page
    @total_count = scope.count
    @total_pages = (@total_count.to_f / per_page).ceil
    @page = [@page, @total_pages].min
  end

  def offset
    (page - 1) * per_page
  end

  def next_page
    page < total_pages ? page + 1 : nil
  end

  def prev_page
    page > 1 ? page - 1 : nil
  end
end
