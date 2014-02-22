CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => ENV['aws_access_key_id'],                        # required
    :aws_secret_access_key  => ENV['aws_secret_access_key'],                        # required
    :region                 => 'us-west-1',                  # optional, defaults to 'us-east-1'
    # optional, defaults to nil
  }
  config.fog_directory  = 'carrier-wave-images'
  config.asset_host     = 'https://s3-us-west-1.amazonaws.com'                    # required
  config.fog_public     = false                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
  # optional, defaults to {}
end
