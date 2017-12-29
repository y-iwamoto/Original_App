class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.boolean :read_flg, default: false
      t.integer :user_id
      t.integer :opponent_user_id

      t.timestamps
    end
  end
end
