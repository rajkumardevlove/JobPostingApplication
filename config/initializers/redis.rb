require 'redis'

redis_url = ENV.fetch('REDIS_URL') { 'redis://localhost:6379/0' }

# Create a Redis connection pool
REDIS_POOL = ConnectionPool.new(size: 5, timeout: 5) do
  Redis.new(url: redis_url, driver: :hiredis)
end

# Define a convenience method
def with_redis(&block)
  REDIS_POOL.with(&block)
end

# Redis namespace for application keys
$redis = Redis::Namespace.new("job_posting_app:#{Rails.env}", redis: Redis.new(url: redis_url))