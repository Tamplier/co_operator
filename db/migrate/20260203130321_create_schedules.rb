class CreateSchedules < ActiveRecord::Migration[8.1]
  def change
    create_table :schedules do |t|
      t.references :owner, null: false, polymorphic: true
      t.string :recurrence_rule, limit: 255, null: true
      t.datetime :reference_date, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.boolean :active, null: false

      t.timestamps
    end

    add_index :schedules, %i[owner_id owner_type reference_date start_time], unique: true
  end
end
