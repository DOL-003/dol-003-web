class AddUuidToModder < ActiveRecord::Migration[7.0]
  def change
    add_column :modders, :uuid, :string
  end
end
