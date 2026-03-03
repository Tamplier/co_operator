# frozen_string_literal: true

class IceCubeRuleType < ActiveRecord::Type::Value
  def cast(value)
    return value if value.is_a?(IceCube::Rule)
    return if value.blank?

    IceCube::Rule.from_yaml(value)
  end

  def serialize(value)
    return if value.blank?

    value.to_yaml
  end
end
