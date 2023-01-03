class AddDimensionsToModderPhoto < ActiveRecord::Migration[7.0]
  def change
    add_column :modder_photos, :width, :integer
    add_column :modder_photos, :height, :integer
  end
end
