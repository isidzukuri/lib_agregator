# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'library/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'library'
  s.version     = Library::VERSION
  s.authors     = ['isidzukuri']
  s.email       = ['axesigon@gmail.com']
  s.homepage    = 'https://github.com'
  s.summary     = 'Library feature'
  s.description = 'Library feature'

  s.files = Dir['{app,config,db,lib}/**/*', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails', '~> 5.1.6'
  s.add_dependency 'mysql2'

  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_bot_rails'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'rb-fsevent', '0.9.8' # Until guard will be fixed
  s.add_development_dependency 'rspec-rails'
end
