module HealthMonitor
  module Providers
    class Base

      def self.provider_name
        @name ||= name.demodulize.downcase
      end

      def check!
        raise NotImplementedError
      end

    end
  end
end