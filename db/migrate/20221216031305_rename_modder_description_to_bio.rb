class RenameModderDescriptionToBio < ActiveRecord::Migration[7.0]
  def change
    rename_column :modders, :description, :bio
  end
end
