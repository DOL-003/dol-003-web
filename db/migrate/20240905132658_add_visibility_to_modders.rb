class AddVisibilityToModders < ActiveRecord::Migration[7.1]
  def change
    add_column :modders, :visibility, :string, null: false, default: 'visible'
  end
end
