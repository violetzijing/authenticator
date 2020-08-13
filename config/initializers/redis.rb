require 'connection_pool'

REDIS_CONFIG = YAML.load(File.open(Rails.root.join("config/redis.yml")))

config = REDIS_CONFIG[Rails.env]

Redis::Objects.redis = ConnectionPool.new(size: config["size"], timeout: config["timeout"]) { Redis.new(:host => config["host"], :port => config["port"]) }
