$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "newapp/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "newapp"
  spec.version     = Newapp::VERSION
  spec.authors     = ["Isidzukuri"]
  spec.email       = ["axesigon@gmail.com"]
  spec.homepage    = "https://github.com/isidzukuri/lib_agregator"
  spec.summary     = "Newapp"
  spec.description = "Newapp"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 5.2.3"

  spec.add_development_dependency "rspec-rails", '~> 3.8'
  spec.add_development_dependency "factory_bot_rails"
  spec.add_development_dependency "ffaker"
  spec.add_development_dependency "database_cleaner"
  spec.add_development_dependency "rails-controller-testing"
end
