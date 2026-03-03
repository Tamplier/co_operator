class CreateExternalIds < ActiveRecord::Migration[8.1]
  def change
    create_table :external_ids do |t|
      t.string :external_id, limit: 255, null: false
      t.references :owner, null: false, polymorphic: true
      t.references :store, null: false, foreign_key: true

      t.timestamps
    end

    add_index :external_ids, %i[owner_id owner_type store_id], unique: true
  end
end
