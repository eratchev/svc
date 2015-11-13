require 'sinatra/contrib/all'
require_relative '../../lib/health_monitor_sinatra'

module Sinatra
  module Health

    module Helpers
    end

    def self.registered(app)
      app.helpers Health::Helpers
      app.set :service_name, 'unknown'

      app.get '/health_check' do
        res = HealthMonitor.check
        content_type :json
        status status_code(res[:status])
        body json res[:results]
      end

    end

  end

  register Health
  register Sinatra::Contrib
end
