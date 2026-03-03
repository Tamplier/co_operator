class CreateSocialEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :social_events do |t|
      t.references :language, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true
      t.string :name, limit: 255
      t.integer :max_players
      t.datetime :start_date

      t.timestamps
    end
  end
end
