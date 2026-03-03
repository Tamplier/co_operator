# frozen_string_literal: true

# == Schema Information
#
# Table name: account_scheduled_games
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  game_id     :integer          not null
#  schedule_id :integer          not null
#
# Indexes
#
#  index_account_scheduled_games_on_game_id                  (game_id)
#  index_account_scheduled_games_on_schedule_id              (schedule_id)
#  index_account_scheduled_games_on_schedule_id_and_game_id  (schedule_id,game_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#  fk_rails_...  (schedule_id => schedules.id)
#
FactoryBot.define do
  factory :account_scheduled_game, class: 'Account::ScheduledGame' do
    schedule { nil }
    game { nil }
  end
end
