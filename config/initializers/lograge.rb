Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.ignore_actions = ['Rails::HealthController#show']
  config.lograge.custom_options = lambda do |event|
    {
      time: Time.now.utc,
      ip: event.payload[:request].remote_ip
    }
  end
end
