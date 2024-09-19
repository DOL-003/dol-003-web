RailsCloudflareTurnstile.configure do |config|
  config.site_key = Rails.application.credentials.dig(:turnstile, :site_key) || '1x00000000000000000000AA'
  config.secret_key = Rails.application.credentials.dig(:turnstile, :secret_key) || '1x0000000000000000000000000000000AA'
  config.fail_open = true
  config.mock_enabled = false
end
