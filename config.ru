require 'rubygems'
require 'bundler'
require 'sinatra/base'

Bundler.require

# pull in the helpers and controllers
Dir.glob('./app/{helpers,controllers}/*.rb').each { |file| require file }

# map the controllers to routes
map('/health_check') { run HealthChecksController }
map('/') { run ApplicationController }