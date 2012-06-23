$redis = Redis.new(
  host: Omniconf.conf.redis.host,
  port: Omniconf.conf.redis.port,
  db: Rails.env.test? ? 1 : 0 # use a different DB for testing environment
)

begin
  $redis.ping
rescue Errno::ECONNREFUSED
  $stderr.puts "Oops, I cannot connect to Redis."
  $stderr.puts "You can start it with `foreman start redis`." if Rails.env.test?
  exit
end
