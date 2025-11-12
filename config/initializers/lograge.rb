Rails.application.configure do
  config.lograge.enabled = true

  config.lograge.custom_options = lambda do |event|
    {
      ip: event.payload[:request].remote_ip
    }
  end
end
