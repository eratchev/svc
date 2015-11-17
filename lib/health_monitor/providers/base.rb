module HealthMonitor
  module Providers
    class Base
      attr_reader :request
      attr_reader :settings

      def self.provider_name
        @name ||= name.demodulize.downcase
      end

      def initialize(request: nil, settings: nil)
        @request = request
        @settings = settings
      end

      def check!
        raise NotImplementedError
      end

    end
  end
end