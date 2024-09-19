RailsCloudflareTurnstile.configure do |config|
  config.site_key = Rails.application.credentials.dig(:turnstile, :site_key)
  config.secret_key = Rails.application.credentials.dig(:turnstile, :secret_key)
  config.fail_open = true
  config.mock_enabled = false
end
