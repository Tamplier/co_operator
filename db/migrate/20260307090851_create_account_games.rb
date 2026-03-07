class CreateAccountGames < ActiveRecord::Migration[8.1]
  def change
    create_table :account_games do |t|
      t.references :account_profile, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end

    add_index :account_games, %i[account_profile_id game_id], unique: true
  end
end
