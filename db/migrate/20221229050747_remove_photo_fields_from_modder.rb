class RemovePhotoFieldsFromModder < ActiveRecord::Migration[7.0]
  def change
    remove_column :modders, :photo_1
    remove_column :modders, :photo_2
    remove_column :modders, :photo_3
    remove_column :modders, :photo_4
    remove_column :modders, :photo_5
    remove_column :modders, :photo_6
    remove_column :modders, :photo_7
    remove_column :modders, :photo_8
    remove_column :modders, :photo_9
    remove_column :modders, :photo_10
  end
end
