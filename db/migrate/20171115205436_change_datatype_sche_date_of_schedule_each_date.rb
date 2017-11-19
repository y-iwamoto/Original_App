class ChangeDatatypeScheDateOfScheduleEachDate < ActiveRecord::Migration[5.1]
  def change
    change_column :schedule_each_dates, :sche_date, :datetime
  end
end
