class AddLogoToModder < ActiveRecord::Migration[7.0]
  def change
    add_column :modders, :logo, :string
  end
end
