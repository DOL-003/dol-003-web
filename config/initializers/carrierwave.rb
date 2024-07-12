CarrierWave.configure do |config|

  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: Rails.application.credentials.dig(:r2, :access_key),
    aws_secret_access_key: Rails.application.credentials.dig(:r2, :access_key_secret),
    region: 'auto',
    endpoint: "https://#{Rails.application.credentials.dig(:r2, :api_account_id)}.r2.cloudflarestorage.com",
    enable_signature_v4_streaming: false
  }
  config.fog_directory  = 'controllers'
  config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" }

  if Rails.env.production?
    config.asset_host = 'https://assets.dol-003.info'
  end

end
