class RemoveNotNullFromModderUserId < ActiveRecord::Migration[7.0]
  def change
    change_column_null :modders, :user_id, true
  end
end
