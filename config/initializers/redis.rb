require 'redis'

# Load the redis.yml configuration file
begin
  redis_config = YAML.load_file(Rails.root + 'config/redis.yml')[Rails.env]
rescue
end

# Connect to Redis using the redis_config host and port, with fallback to localhost for stag/dev
if redis_config
  $redis = Redis.new(host: redis_config['host'], port: redis_config['port'])
else
  $redis = Redis.new(:host => 'localhost', :port => 6379)
end