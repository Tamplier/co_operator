# frozen_string_literal: true

module Avo
  class BasePolicy < ApplicationPolicy
    def index?
      user.admin?
    end

    def show?
      user.admin?
    end

    def create?
      user.admin?
    end

    def update?
      user.admin?
    end

    def destroy?
      user.admin?
    end
  end
end
