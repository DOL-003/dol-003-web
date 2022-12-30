class CreateModderPhotos < ActiveRecord::Migration[7.0]
  def change
    create_table :modder_photos do |t|
      t.references :modder, null: false
      t.string :uuid, null: false
      t.string :photo, null: false
      t.integer :index, null: false

      t.timestamps
    end
  end
end
