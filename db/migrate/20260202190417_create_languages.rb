class CreateLanguages < ActiveRecord::Migration[8.1]
  def change
    create_table :languages do |t|
      t.string :code, limit: 10, null: false
      t.string :name, limit: 255, null: false

      t.index :code, unique: true
      t.timestamps
    end
  end
end
