# == Schema Information
#
# Table name: account_games
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  account_profile_id :bigint           not null
#  game_id            :bigint           not null
#
# Indexes
#
#  index_account_games_on_account_profile_id              (account_profile_id)
#  index_account_games_on_account_profile_id_and_game_id  (account_profile_id,game_id) UNIQUE
#  index_account_games_on_game_id                         (game_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_profile_id => account_profiles.id)
#  fk_rails_...  (game_id => games.id)
#
FactoryBot.define do
  factory :account_game, class: 'Account::Game' do
    account_profile { nil }
    game { nil }
  end
end
