class AddColumnToNotification < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :introduce_flg, :boolean
    add_column :notifications, :content, :string
  end
end
