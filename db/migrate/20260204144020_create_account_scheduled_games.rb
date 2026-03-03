class CreateAccountScheduledGames < ActiveRecord::Migration[8.1]
  def change
    create_table :account_scheduled_games do |t|
      t.references :schedule, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end

    add_index :account_scheduled_games, %i[schedule_id game_id], unique: true
  end
end
