class CreateScheduleEachDates < ActiveRecord::Migration[5.1]
  def change
    create_table :schedule_each_dates do |t|
      t.integer :user_id
      t.integer :schedule_id
      t.date :sche_date

      t.timestamps
    end
  end
end
