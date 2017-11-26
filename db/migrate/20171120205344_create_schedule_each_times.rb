class CreateScheduleEachTimes < ActiveRecord::Migration[5.1]
  def change
    create_table :schedule_each_times do |t|
      t.integer :schedule_id
      t.integer :schedule_each_date_id
      t.integer :user_id
      t.integer :place_id
      t.string :memo
      t.time :from_time
      t.time :to_time

      t.timestamps
    end
  end
end
