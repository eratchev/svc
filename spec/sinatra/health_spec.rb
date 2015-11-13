require 'spec_helper'

describe 'Health API' do
  class App < Sinatra::Base
    register Sinatra::Health
    set :service_name, 'testing'
  end

  def app
    App
  end

  describe 'GET /health_check' do
    before do
      get '/health_check'
    end

    it 'is successful' do
      expect(last_response.status).to eq 200
    end

    it 'returns health check' do
      check = JSON.parse(last_response.body)
      expect(check['service']).to eq('testing')
      expect(check['providers']).not_to be nil
      expect(check['providers']).to eq('TODO')
    end
  end


end