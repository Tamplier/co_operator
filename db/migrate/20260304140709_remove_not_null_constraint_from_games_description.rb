class RemoveNotNullConstraintFromGamesDescription < ActiveRecord::Migration[8.1]
  def change
    add_column :games, :last_modified, :bigint, default: 0
    change_column_null :games, :description, true
  end
end
