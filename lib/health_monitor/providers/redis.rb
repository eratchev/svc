require 'redis'

module HealthMonitor
  module Providers
    class RedisException < StandardError; end

    class Redis < Base
      def check!
        time = Time.now.to_s(:db)

        redis = ::Redis.new(url: settings.redis_url)
        redis.set(key, time)
        fetched = redis.get(key)

        raise "different values (now: #{time}, fetched: #{fetched})" if fetched != time
      rescue Exception => e
        raise RedisException.new(e.message)
      ensure
        redis.client.disconnect
      end

      private

      def key
        @key ||= ['health', request.ip].join(':')
      end
    end
  end
end