class InvitationsController < ApplicationController

  INVITES_PER_MONTH = 5

  before_action :authenticate_user!

  def new
    @available_invitations = available_invitations
    @unlimited_invitations = flag_enabled?(:unlimited_invitations)
    @invites_per_month = INVITES_PER_MONTH
  end

  def create
    respond_to do |format|

      format.html do
        return redirect_to new_invitation_path if params[:email].blank?

        unless flag_enabled?(:unlimited_invitations) || available_invitations.positive?
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
        unless flag_enabled?(:unlimited_invitations) || available_invitations.positive?
          return render json: {
            success: false
          }
        end

        invitation = UserInvitation.new
        invitation.inviter_user = current_user
        invitation.save!

        render json: {
          success: true,
          invitation_url: invitation.registration_url,
          available_invitations:
        }
      end

    end
  end

  private

  def available_invitations
    return nil if flag_enabled?(:unlimited_invitations)
    invites_in_last_30_days = UserInvitation.where(inviter_user: current_user).where('created_at > ?', 30.days.ago).count
    INVITES_PER_MONTH - invites_in_last_30_days
  end

end
