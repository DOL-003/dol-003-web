class ApplicationMailer < ActionMailer::Base
  after_deliver :log_delivery
  default from: 'no-reply@dol-003.info'
  layout 'mailer'

  def log_delivery
    Rails.logger.info "Sent email: #{mailer_name}##{action_name}"
    EventLog.log 'sent_email', {
      mailer: mailer_name,
      email_name: action_name,
      params:
    }
  end
end
