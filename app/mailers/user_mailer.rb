class UserMailer < ApplicationMailer

  def invitation
    @inviter_modder = User.find(params[:inviter_user_id]).modder
    @invitation_token = params[:invitation_token]

    mail(
      to: params[:email],
      subject: 'Your invitation to join DOL-003.info'
    )
  end

  def warn_inactive
    @user = User.find(params[:user_id])
    @modder = @user.modder

    mail(
      to: @user.email,
      subject: 'Action requested: You will be marked inactive on DOL-003.info'
    )
  end

  def mark_inactive
    @user = User.find(params[:user_id])
    @modder = @user.modder

    mail(
      to: @user.email,
      subject: 'Attention: You have been marked inactive on DOL-003.info'
    )
  end

end
