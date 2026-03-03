class CreateAccountFriendRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :account_friend_requests do |t|
      t.references :requester, null: false, foreign_key: { to_table: :account_profiles }
      t.references :recipient, null: false, foreign_key: { to_table: :account_profiles }
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :account_friend_requests, %i[requester_id recipient_id],
              unique: true,
              where: 'status != 1'
  end
end
