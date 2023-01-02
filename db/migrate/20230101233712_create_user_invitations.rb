class CreateUserInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :user_invitations do |t|
      t.references :user
      t.string :claim_token
      t.string :status, null: false

      t.timestamps
    end
    add_index :user_invitations, :claim_token
  end
end
