class UserMailerPreview < ActionMailer::Preview

  def invitation
    UserMailer.with(email: 'abc@def.ghi', invitation_token: 'abc123').invitation
  end

end
