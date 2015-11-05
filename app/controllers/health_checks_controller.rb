require 'json'

class HealthChecksController < ApplicationController


  get '/' do
    content_type :json
    status status_code
    body status_hash.to_json
  end


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