
module HealthMonitor
  STATUSES = {
      ok: 'OK',
      error: 'ERROR'
  }.freeze

  extend self

  attr_accessor :configuration

  def configure
    self.configuration ||= Configuration.new

    yield configuration if block_given?
  end

  def check(request)
    results = configuration.providers.map { |provider| provider_result(provider, request) }

    {
        results: results,
        status: results.all? { |res| res.values.first[:status] == STATUSES[:ok] } ? :ok : :service_unavailable
    }
  end

  private

  def provider_result(provider, request)
    monitor = provider.new(request: request)
    monitor.check!

    {
        provider.provider_name => {
            message: '',
            status: STATUSES[:ok],
            timestamp: Time.now.to_s(:db)
        }
    }
  rescue => e

    {
        provider.provider_name => {
            message: e.message,
            status: STATUSES[:error],
            timestamp: Time.now.to_s(:db)
        }
    }
  end
end

HealthMonitor.configure
