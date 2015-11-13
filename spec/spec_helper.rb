ENV['RACK_ENV'] ||= 'test'
require 'rack/test'
require 'sinatra/base'

Dir.glob('./lib/{sinatra}/*.rb').each { |file| require file }

RSpec.configure do |config|
  config.include Rack::Test::Methods
end