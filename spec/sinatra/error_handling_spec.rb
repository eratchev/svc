require 'spec_helper'

describe Sinatra::ErrorHandling do
  class App < Sinatra::Base
    register Sinatra::ErrorHandling
    set :service_name, 'testing'

    get '/not_found' do
      raise ActiveRecord::RecordNotFound
    end

    get '/decode_error' do
      raise MultiJson::DecodeError
    end

  end

  let(:browser) { Rack::Test::Session.new(Rack::MockSession.new(App, 'myapp.dev')) }

  describe 'GET /not_found' do
    it 'is 404' do
      browser.get '/not_found'
      expect_404
    end
  end
  describe 'GET /decode_error' do
    it 'is 400' do
      browser.get '/decode_error'
      expect_400('Problems parsing JSON')
    end
  end


end