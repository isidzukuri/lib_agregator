require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LibAgreagator
  class Application < Rails::Application
    $cache = ActiveSupport::Cache::MemCacheStore.new

    config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths += Dir["#{Rails.root}/app/serializers/**/"]
    config.autoload_paths += Dir["#{Rails.root}/app/services/**"]
    config.exceptions_app = self.routes
  end
end
