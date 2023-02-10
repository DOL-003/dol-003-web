class InvitationsController < ApplicationController

  before_action :authenticate_user!

  def new
    @available_invitations = available_invitations
    @unlimited_invitations = flag_enabled?(:unlimited_invitations)
  end

  def create
    respond_to do |format|

      format.html do
        return redirect_to new_invitation_path if params[:email].blank?

        unless available_invitations.positive? || flag_enabled?(:unlimited_invitations)
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

      format.json do
        unless available_invitations.positive? || flag_enabled?(:unlimited_invitations)
          return render json: {
            success: false
          }
        end

        invitation = UserInvitation.new
        invitation.inviter_user = current_user
        invitation.save!

        render json: {
          success: true,
          invitation_url: invitation.registration_url
        }
      end

    end
  end

  private

  def available_invitations
    invites_in_last_30_days = UserInvitation.where(inviter_user: current_user).where('created_at > ?', 30.days.ago).count
    5 - invites_in_last_30_days
  end

end
