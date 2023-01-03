class AdminMailerPreview < ActionMailer::Preview

  def new_modder
    AdminMailer.with(modder: Modder.first).new_modder
  end

end
