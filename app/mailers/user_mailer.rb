class UserMailer < ApplicationMailer

  def invitation
    @invitation_token = params[:invitation_token]

    mail(
      to: params[:email],
      subject: 'Your invitation to join DOL-003.info'
    )
  end

end
