require 'spec_helper'

describe 'Health API' do
  class App < Sinatra::Base
    register Sinatra::Health
    set :service_name, 'testing'
  end

  def app
    App
  end


  let(:time) { Time.local(1990) }

  before do
    Timecop.freeze(time)
  end

  after do
    Timecop.return
  end

  describe 'GET /health_check' do
    it 'is successful' do
      get '/health_check'
      expect(last_response.status).to eq 200

      expect(JSON.parse(last_response.body)).to eq([ {'database'=>
                                          {'message'=>'', 'status'=>'OK', 'timestamp'=>time.to_s(:db)}}
                                        ])
    end


    context 'failing' do
      before do
        allow(ActiveRecord::Migrator).to receive(:current_version).and_raise(Exception)
      end

      it 'should fail' do
        get '/health_check'

        expect(last_response.status).to eq 503
        expect(JSON.parse(last_response.body)).to eq([ {'database'=>
                                                            {'message'=>'Exception', 'status'=>'ERROR', 'timestamp'=>time.to_s(:db)}}
                                                     ])

      end
    end


  end


end