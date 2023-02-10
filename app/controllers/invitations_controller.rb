class InvitationsController < ApplicationController

  before_action :authenticate_user!

  def new
    @available_invitations = available_invitations
  end

  def create
    return redirect_to new_invitation_path if params[:email].blank?

    unless available_invitations.positive?
      flash[:error] = 'You do not currently have any invitations. Try again later.'
      return redirect_to new_invitation_path
    end

    invitation = UserInvitation.new
    invitation.inviter_user = current_user
    invitation.email = params[:email]
    invitation.save!

    invitation.send_email

    flash[:notice] = 'Invitation sent!'

    redirect_to new_invitation_path
  end

  private

  def available_invitations
    invites_in_last_30_days = UserInvitation.where(inviter_user: current_user).where('created_at > ?', 30.days.ago).count
    5 - invites_in_last_30_days
  end

end
