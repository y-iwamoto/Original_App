class CreateSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :schedules do |t|
      t.integer :user_id
      t.date :from_date
      t.date :to_date
      t.string :title
      t.string :memo

      t.timestamps
    end
  end
end
