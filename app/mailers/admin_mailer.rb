class AdminMailer < ApplicationMailer

  def new_modder
    @modder = params[:modder]

    mail(
      to: 'Jeremy Marquis <jeremy@jeremymarquis.com>',
      subject: 'A new modder has signed up for DOL-003'
    )
  end

end
