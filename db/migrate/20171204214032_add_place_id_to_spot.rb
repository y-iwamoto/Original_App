class AddPlaceIdToSpot < ActiveRecord::Migration[5.1]
  def change
    add_column :spots, :place_id, :string
  end
end
