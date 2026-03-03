# frozen_string_literal: true

class ApplicationService
  class InvalidStateError < StandardError; end

  include Pundit::Authorization

  Result = Struct.new(:success?, :result, :error, keyword_init: true)

  def self.call!(...)
    new(...).call
  end

  def self.call(...)
    service = new(...)
    service.call
  rescue StandardError => e
    service.send(:failure, e.message)
  end

  protected

  def authorize(record, query)
    super
  rescue Pundit::NotAuthorizedError
    raise Pundit::NotAuthorizedError, 'You are not authorized to perform this action'
  end

  def success(result = nil)
    Result.new(success?: true, result: result)
  end

  def failure(error = nil)
    Result.new(success?: false, error: error)
  end
end
