class AddTitleNormalizedToGames < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL
      ALTER TABLE games
      ADD COLUMN title_normalized text
      GENERATED ALWAYS AS (
        lower(regexp_replace(title, '[^a-zA-Zа-яА-Я0-9\\s]+', ' ', 'g'))
      ) STORED;
    SQL

    execute <<~SQL
      CREATE INDEX index_games_on_title_normalized_trgm
      ON games USING gin(title_normalized gin_trgm_ops);
    SQL

    remove_index :games, name: :index_games_on_title
  end

  def down
    remove_index :games, name: :index_games_on_title_normalized_trgm
    remove_column :games, :title_normalized
    add_index :games, :title, using: :gin, opclass: :gin_trgm_ops
  end
end
