class AddPreviewUrlToStores < ActiveRecord::Migration[8.1]
  def change
    add_column :stores, :image_link_pattern, :jsonb, default: {}
  end
end
