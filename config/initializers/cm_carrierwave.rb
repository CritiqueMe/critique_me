if Rails.env.test?
  # ============ TEST MODE (local filesystem; no image processing)
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false

  end
elsif Rails.env == 'development'
  # ============ DEVELOPMENT MODE (local filesystem; does image processing)
  CarrierWave.configure do |config|
    config.storage = :file
  end
else
  CarrierWave.configure do |config|
    # ============ PRODUCTION MODE (push to AWS; does image processing)
    if Rails.env == 'production'
      env_dir = 'cmprod'
      #env_cdn = 'http://c683851.r51.cf2.rackcdn.com'
    # ============ STAGING MODE (push to AWS (staging); does image processing)
    elsif Rails.env == 'staging'
      env_dir = 'sb_stg'
      #env_cdn = 'http://c750437.r37.cf2.rackcdn.com'
    end

    config.fog_credentials = {
      :provider           => 'AWS',
      :aws_access_key_id => 'AKIAJ277DJAIT4HZGJ7Q',
      :aws_secret_access_key  => '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',
      :region => 'us-east-1'
    }
    config.fog_directory = env_dir
    #config.fog_host = env_cdn
    config.fog_public = true
  end
end