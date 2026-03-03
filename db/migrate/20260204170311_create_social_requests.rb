class CreateSocialRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :social_requests do |t|
      t.references :target_profile, null: false, foreign_key: { to_table: :account_profiles }
      t.references :social_event, null: false, foreign_key: true
      t.integer :status, default: 0
      t.integer :request_type

      t.timestamps
    end

    add_index :social_requests, %i[target_profile_id social_event_id request_type],
              unique: true,
              where: 'status != 1'
  end
end
