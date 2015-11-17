require 'sidekiq/api'

module HealthMonitor
  module Providers
    class SidekiqException < StandardError; end

    class Sidekiq < Base
      DEFAULT_LATENCY_TIMEOUT = 30.freeze

      def check!
        check_workers!
        check_latency!
        check_redis!
      rescue Exception => e
        raise SidekiqException.new(e.message)
      end

      private


      def check_workers!
        ::Sidekiq::Workers.new.size
      end

      def check_latency!
        latency = ::Sidekiq::Queue.new.latency

        return unless latency > DEFAULT_LATENCY_TIMEOUT

        raise "latency #{latency} is greater than #{DEFAULT_LATENCY_TIMEOUT}"
      end

      def check_redis!
        ::Sidekiq.redis(&:info)
      end
    end
  end
end