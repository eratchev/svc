$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'svc/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'svc'
  s.version     = Svc::VERSION
  s.authors     = ['Evgueni Ratchev']
  s.email       = ['infrastructure@bespoke.is']
  s.homepage    = 'https://www.myavatire.com'
  s.summary     = 'Gem providing common functionality for all services'
  s.description = 'Gem providing common functionality for all services, such as a health-check api'

  s.files = Dir['{lib}/**/*', 'README.md']

  s.add_dependency 'activerecord'
  s.add_dependency 'pg'
  s.add_dependency 'rake'
  s.add_dependency 'sidekiq'
  s.add_dependency 'sidekiq-statistic'
  s.add_dependency 'sinatra'
  s.add_dependency 'sinatra-activerecord'
  s.add_dependency 'sinatra-initializers'
  s.add_dependency 'sinatra-contrib'
end
