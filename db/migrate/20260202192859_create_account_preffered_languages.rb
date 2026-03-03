class CreateAccountPrefferedLanguages < ActiveRecord::Migration[8.1]
  def change
    create_table :account_preffered_languages do |t|
      t.references :account_profile, null: false, foreign_key: true
      t.references :language, null: false, foreign_key: true
      t.integer :priority, null: false

      t.timestamps
    end

    add_index :account_preffered_languages, %i[account_profile_id language_id], unique: true
  end
end
