class CreateModderServices < ActiveRecord::Migration[7.0]
  def change
    create_table :modder_services do |t|
      t.references :modder, null: false
      t.string :service, null: false
      t.integer :index, null: false

      t.timestamps
    end
  end
end
