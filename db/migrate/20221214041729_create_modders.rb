class CreateModders < ActiveRecord::Migration[7.0]
  def change
    create_table :modders do |t|
      t.references :user, null: false
      t.string :name, null: false
      t.string :slug, null: false
      t.string :description
      t.string :twitter_username
      t.string :etsy_shop
      t.string :website_url
      t.string :featured_link
      t.string :status, null: false

      t.timestamps
    end

    add_index :modders, :slug, unique: true
  end
end
