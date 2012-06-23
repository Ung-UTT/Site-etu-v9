$redis = Redis.new(
  host: 'localhost', # TODO: extract these settings
  port: 6379,
  db: Rails.env.test? ? 1 : 0 # use a different DB for testing environment
)

begin
  $redis.ping
rescue Errno::ECONNREFUSED
  $stderr.puts "Oops, I cannot connect to Redis."
  $stderr.puts "You can start it with `foreman start redis`." if Rails.env.test?
  raise
end

