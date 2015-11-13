require 'sinatra/contrib/all'

module Sinatra
  module Health

    module Helpers
    end

    def self.registered(app)
      app.helpers Health::Helpers
      app.set :service_name, 'unknown'

      app.get '/health_check' do
        content_type :json
        status 200
        body json :service => settings.service_name, :server_time => Time.now
      end

    end

  end

  register Health
  register Sinatra::Contrib
end
