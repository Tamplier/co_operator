class AddStoreIdUpdatedAtIndexToExternalIds < ActiveRecord::Migration[8.1]
  def change
    add_index :external_ids, %i[external_id updated_at]
  end
end
