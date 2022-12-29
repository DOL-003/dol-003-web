class AddPhotoFieldsToModder < ActiveRecord::Migration[7.0]
  def change
    add_column :modders, :photo_1, :string
    add_column :modders, :photo_2, :string
    add_column :modders, :photo_3, :string
    add_column :modders, :photo_4, :string
    add_column :modders, :photo_5, :string
    add_column :modders, :photo_6, :string
    add_column :modders, :photo_7, :string
    add_column :modders, :photo_8, :string
    add_column :modders, :photo_9, :string
    add_column :modders, :photo_10, :string
  end
end
