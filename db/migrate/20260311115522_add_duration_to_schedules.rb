class AddDurationToSchedules < ActiveRecord::Migration[8.1]
  def change
    add_column :schedules, :duration, :integer, null: false
    remove_column :schedules, :end_time, :time
    remove_column :schedules, :start_time, :time
  end
end
