require 'sinatra/base'
require 'sinatra/activerecord'
require 'multi_json'

module Sinatra
  module ErrorHandling

    module Helpers
      def halt_with_400_bad_request(message = nil)
        message ||= 'Bad request'
        halt 400, json({ message: message })
      end

      def halt_with_401_authorization_required(message = nil, realm = "App Name")
        message ||= 'Authorization required'
        headers 'WWW-Authenticate' => %(Basic realm="#{realm}")
        halt 401, json({ message: message })
      end

      def halt_with_403_forbidden_error(message = nil)
        message ||= 'Forbidden'
        halt 403, json({ message: message })
      end

      def halt_with_404_not_found
        halt 404, json({ message: 'Not found' })
      end

      def halt_with_422_unprocessible_entity
        errors = []
        resource = env['sinatra.error'].record.class.to_s
        env['sinatra.error'].record.errors.each do |attribute, message|

          code = case message
                   when 'can\'t be blank'
                     'missing_field'
                   when 'has already been taken'
                     'already_exists'
                   else
                     'invalid'
                 end

          errors << {
              resource: resource,
              field: attribute,
              code: code
          }
        end
        halt 422, json({
                           message: 'Validation failed',
                           errors: errors
                       })
      end

      def halt_with_500_internal_server_error(message = nil)
        message ||= 'Internal server error'
        halt 500, json({message: message})
      end
    end

    def self.registered(app)
      app.helpers ErrorHandling::Helpers

      app.error ActiveRecord::RecordNotFound do
        halt_with_404_not_found
      end

      app.error ActiveRecord::RecordInvalid do
        halt_with_422_unprocessible_entity
      end

      app.error ActiveRecord::UnknownAttributeError do
        halt_with_422_unprocessible_entity
      end

      app.error ActiveRecord::DeleteRestrictionError do
        halt_with_400_bad_request
      end

      app.error MultiJson::DecodeError do
        halt_with_400_bad_request('Problems parsing JSON')
      end

      app.error do
        if ::Exceptional::Config.should_send_to_api?
          ::Exceptional::Remote.error(::Exceptional::ExceptionData.new(env['sinatra.error']))
        end
        halt_with_500_internal_server_error
      end
    end

  end
  register ErrorHandling
end