CarrierWave.configure do |config|

  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: Rails.application.credentials.dig(:spaces, :access_key),
    aws_secret_access_key: Rails.application.credentials.dig(:spaces, :access_key_secret),
    region: 'nyc3',
    endpoint: 'https://nyc3.digitaloceanspaces.com'
  }
  config.fog_directory  = 'controllers-photos'
  config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" }

end
