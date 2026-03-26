class AddDurationToSocialEvents < ActiveRecord::Migration[8.1]
  def change
    add_column :social_events, :duration, :integer, null: false
  end
end
