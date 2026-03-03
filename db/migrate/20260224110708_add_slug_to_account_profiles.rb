class AddSlugToAccountProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :account_profiles, :slug, :string
    add_index :account_profiles, :slug, unique: true
  end
end
