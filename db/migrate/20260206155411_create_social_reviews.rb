class CreateSocialReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :social_reviews do |t|
      t.references :author, null: false, foreign_key: { to_table: :account_profile }
      t.references :target, null: false, polymorphic: true
      t.string :text, limit: 2048
      t.integer :rating, null: false

      t.timestamps
    end

    add_index :social_reviews, %i[author_id target_id target_type], unique: true
  end
end
