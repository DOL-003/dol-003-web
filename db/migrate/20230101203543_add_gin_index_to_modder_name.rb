class AddGinIndexToModderName < ActiveRecord::Migration[7.0]
  def change
    enable_extension :pg_trgm
    add_index :modders, :name, opclass: :gin_trgm_ops, using: :gin
  end
end
