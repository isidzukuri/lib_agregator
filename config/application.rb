require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LibAgreagator
  CACHE = ActiveSupport::Cache::MemCacheStore.new

  class Application < Rails::Application
    config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths += Dir["#{Rails.root}/app/serializers/**/"]
    config.autoload_paths += Dir["#{Rails.root}/app/services/**"]
    config.autoload_paths += Dir["#{Rails.root}/app/queries/**"]
    config.exceptions_app = self.routes
  end
end
