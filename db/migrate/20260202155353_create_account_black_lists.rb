class CreateAccountBlackLists < ActiveRecord::Migration[8.1]
  def change
    create_table :account_black_lists do |t|
      t.references :requester, null: false, foreign_key: { to_table: :account_profiles}
      t.references :target, null: false, foreign_key: { to_table: :account_profiles}

      t.timestamps
    end

    add_index :account_black_lists, %i[requester_id target_id], unique: true
  end
end
