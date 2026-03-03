class CreateAccountProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :account_profiles do |t|
      t.references :user, null: false
      t.string :name, limit: 255, null: false
      t.float :rating
      t.string :timezone, limit: 255, default: 'UTC', null: false

      t.timestamps
    end
  end
end
