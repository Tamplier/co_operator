# frozen_string_literal: true

# == Schema Information
#
# Table name: games
#
#  id               :bigint           not null, primary key
#  description      :string(300)
#  last_modified    :bigint           default(0)
#  rating           :float
#  title            :string(255)      not null
#  title_normalized :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_games_on_title_normalized_trgm  (title_normalized) USING gin
#
FactoryBot.define do
  factory :game, class: 'Game' do
    title { Faker::Game.title }
    description { Faker::Lorem.paragraph }
  end
end
