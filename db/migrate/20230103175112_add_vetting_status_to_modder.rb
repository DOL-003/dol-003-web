class AddVettingStatusToModder < ActiveRecord::Migration[7.0]
  def change
    add_column :modders, :vetting_status, :string
    add_index :modders, :vetting_status
  end
end
