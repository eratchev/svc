require 'json'

module Sinatra
  module Health

    module Helpers

      private

      def status_hash
        @status_hash ||= {
            application: 'TODO',
            server_time: Time.now
        }
      end

      def status_code
        200
      end

    end

    def self.registered(app)
      app.helpers Health::Helpers

      app.get '/health_check' do
        content_type :json
        status status_code
        body status_hash.to_json
      end

    end

  end

  register Health
end
