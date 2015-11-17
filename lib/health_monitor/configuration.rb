module HealthMonitor
  class Configuration
    PROVIDERS = [:database, :redis, :sidekiq].freeze

    attr_accessor :error_callback
    attr_reader :providers

    def initialize
      database
    end

    PROVIDERS.each do |provider_name|
      define_method provider_name do |&_block|
        require "health_monitor/providers/#{provider_name}"

        add_provider("HealthMonitor::Providers::#{provider_name.capitalize}".constantize)
      end
    end

    private

    def add_provider(provider_class)
      (@providers ||= Set.new) << provider_class

      provider_class
    end
  end
end