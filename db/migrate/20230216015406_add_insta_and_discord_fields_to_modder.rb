class AddInstaAndDiscordFieldsToModder < ActiveRecord::Migration[7.0]
  def change
    add_column :modders, :instagram_username, :string
    add_column :modders, :discord_username, :string
  end
end
