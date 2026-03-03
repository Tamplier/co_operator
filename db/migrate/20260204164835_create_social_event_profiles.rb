class CreateSocialEventProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :social_event_profiles do |t|
      t.references :social_event, null: false, foreign_key: true
      t.references :account_profile, null: false, foreign_key: true

      t.timestamps
    end

    add_index :social_event_profiles, %i[social_event_id account_profile_id], unique: true
  end
end
