class CreateSocialMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :social_messages do |t|
      t.references :author, null: false, foreign_key: { to_table: :account_profiles }
      t.references :recipient, null: false, polymorphic: true
      t.string :text, limit: 2048

      t.timestamps
    end
  end
end
