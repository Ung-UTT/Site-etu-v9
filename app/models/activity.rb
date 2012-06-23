class Activity
  class << self
    LIST = 'activities'

    def add(activity)
      $redis.lpush LIST, activity.to_json
    end

    def get(index)
      if (activity = $redis.lindex LIST, index)
        JSON.parse(activity)
      end
    end

    def last(number)
      $redis.lrange(LIST, 0, (number - 1)).map do |activity|
        JSON.parse activity
      end
    end

    def flush!
      while $redis.llen(LIST) > 0 do
        $redis.rpop LIST
      end
    end
  end
end

