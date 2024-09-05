class RemoveModderVisibilityDefault < ActiveRecord::Migration[7.1]
  def change
    change_column_default :modders, :visibility, nil
  end
end
