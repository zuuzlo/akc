CarrierWave.configure do |config|
  #config.fog_provider = 'fog/aws'
  config.aws_credentials = {
    # Configuration for Amazon S3
    #:provider              => 'AWS',
    :access_key_id     => ENV['AWS_ACCESS_KEY_ID'],
    :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
    :region                => 'us-east-1'
  }

  if Rails.env.test?
    config.storage = :file
    config.enable_processing = false
    config.root = "#{Rails.root}/tmp"
  elsif Rails.env.development?
    config.storage = :aws
    config.aws_bucket = 'testakc'
  else
    config.storage = :aws
    config.aws_bucket = 'akcimages'
  end
  config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7
  config.aws_attributes = {
    expires: 1.week.from_now.httpdate,
    cache_control: 'max-age=604800'
  }
  #config.cache_dir = "#{Rails.root}/tmp/uploads"
  #config.fog_attributes = { 'Cache-Control'=>"max-age=#{365.day.to_i}" }
end