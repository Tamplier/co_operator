class CreateStores < ActiveRecord::Migration[8.1]
  def change
    create_table :stores do |t|
      t.string :title, limit: 255, null: false
      t.string :game_link_pattern, limit: 255, null: false
      t.string :profile_link_pattern, limit: 255, null: false

      t.timestamps
    end
  end
end
