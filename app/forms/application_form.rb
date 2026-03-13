# frozen_string_literal: true

class ApplicationForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  def self.model_name
    ActiveModel::Name.new(self, nil, name.sub(/Form$/, ''))
  end
end
