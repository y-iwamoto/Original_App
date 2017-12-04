class CreateFavoriteSpots < ActiveRecord::Migration[5.1]
  def change
    create_table :favorite_spots do |t|
      t.integer :user_id
      t.integer :spot_id

      t.timestamps
    end
  end
end
