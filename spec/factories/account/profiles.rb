# frozen_string_literal: true

# == Schema Information
#
# Table name: account_profiles
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  rating     :float
#  slug       :string
#  timezone   :string(255)      default("UTC"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_account_profiles_on_slug     (slug) UNIQUE
#  index_account_profiles_on_user_id  (user_id)
#
FactoryBot.define do
  factory :account_profile, class: 'Account::Profile' do
    association :user

    name { Faker::Name.name }
  end
end
