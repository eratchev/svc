ENV['RACK_ENV'] ||= 'test'
require 'rack/test'
require 'sinatra/base'
require 'timecop'

Dir.glob('./lib/{sinatra,health_monitor}/*.rb').each { |file| require file }
Dir.glob('./lib/health_monitor/providers/*.rb').each { |file| require file }

RSpec.configure do |config|
  config.include Rack::Test::Methods
end