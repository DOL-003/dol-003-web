class AddLocationToModder < ActiveRecord::Migration[7.0]
  def change
    add_column :modders, :city, :string
    add_column :modders, :latitude, :string
    add_column :modders, :longitude, :string
  end
end
