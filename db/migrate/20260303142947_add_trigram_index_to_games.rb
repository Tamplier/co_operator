class AddTrigramIndexToGames < ActiveRecord::Migration[8.1]
  def change
    add_index :games, :title, using: :gin, opclass: :gin_trgm_ops
  end
end
