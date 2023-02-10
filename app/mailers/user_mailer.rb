class UserMailer < ApplicationMailer

  def invitation
    @inviter_modder = User.find(params[:inviter_user_id]).modder
    @invitation_token = params[:invitation_token]

    mail(
      to: params[:email],
      subject: 'Your invitation to join DOL-003.info'
    )
  end

end
