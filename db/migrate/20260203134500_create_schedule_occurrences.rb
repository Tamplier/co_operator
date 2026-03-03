class CreateScheduleOccurrences < ActiveRecord::Migration[8.1]
  def change
    create_table :schedule_occurrences do |t|
      t.references :schedule, null: false, foreign_key: true
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false

      t.timestamps
    end

    add_index :schedule_occurrences, %i[schedule_id start_at], unique: true
  end
end
