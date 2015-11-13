module HealthMonitor
  module Providers
    class Base
      attr_reader :request

      def self.provider_name
        @name ||= name.demodulize.downcase
      end

      def initialize(request: nil)
        @request = request
      end

      def check!
        raise NotImplementedError
      end

    end
  end
end