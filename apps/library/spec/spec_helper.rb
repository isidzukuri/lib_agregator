# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('dummy/config/environment', __dir__)
# require File.expand_path("../../../../config/environment", __FILE__)

require 'rspec/rails'
require 'factory_bot_rails'

require 'library'

Dir[Library::Engine.root.join('spec/support/**/*.rb')].each { |file| require file }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  unless ENV['SKIP_DATABASE_CLEANER']
    require 'database_cleaner'

    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:transaction)
    end

    config.after(:each, database: true) do |_example|
      DatabaseCleaner.clean
    end
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.include FactoryBot::Syntax::Methods
  config.include Library::Engine.routes.url_helpers
  config.use_transactional_fixtures = true
  config.disable_monkey_patching!
  config.profile_examples = nil
  config.order = :random
  config.expose_dsl_globally = true
end
