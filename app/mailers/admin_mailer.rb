class AdminMailer < ApplicationMailer

  def new_modder
    @modder = params[:modder]

    mail(
      to: 'Jeremy Marquis <jeremy@jeremymarquis.com>',
      subject: 'A new modder has signed up for DOL-003.info'
    )
  end

  def report_modder
    @modder = Modder.find(params[:modder_id])
    @email = params[:email]
    @details = params[:details]

    mail(
      to: 'Jeremy Marquis <jeremy@jeremymarquis.com>',
      subject: 'A modder was reported on DOL-003.info'
    )
  end

end
