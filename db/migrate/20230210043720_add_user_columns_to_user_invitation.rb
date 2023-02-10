class AddUserColumnsToUserInvitation < ActiveRecord::Migration[7.0]
  def change
    add_reference :user_invitations, :inviter_user
    add_column :user_invitations, :email, :string
    rename_column :user_invitations, :user_id, :invitee_user_id
  end
end
