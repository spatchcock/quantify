require 'rubygems'
require 'bundler/setup'
require 'quantify'

Dir["#{File.dirname(__FILE__)}/app/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run :focus => true
  config.filter_run_excluding :broken => true
  config.run_all_when_everything_filtered = true
end
