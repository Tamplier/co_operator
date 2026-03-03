class CreateSocialVotes < ActiveRecord::Migration[8.1]
  def change
    create_table :social_votes do |t|
      t.references :social_request, null: false, foreign_key: true
      t.references :account_profile, null: false, foreign_key: true
      t.integer :decision, null: false

      t.timestamps
    end

    add_index :social_votes, %i[social_request_id account_profile_id], unique: true
  end
end
