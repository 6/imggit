ENV['RACK_ENV'] = 'test'
require File.expand_path("../../config/environment", __FILE__)

require 'rspec/rails'
require 'rspec/autorun'
require 'webmock/rspec'
require 'database_cleaner'
require 'factory_girl_rails'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.order = "random"
  config.use_transactional_fixtures = true
  config.use_transactional_examples = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
