class AddFavoriteFlgToSpots < ActiveRecord::Migration[5.1]
  def change
    add_column :spots, :favorite_flg, :boolean
  end
end
