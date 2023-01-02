class CreateModderInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :modder_invitations do |t|
      t.references :modder
      t.string :claim_token
      t.string :status, null: false

      t.timestamps
    end
    add_index :modder_invitations, :claim_token
  end
end
