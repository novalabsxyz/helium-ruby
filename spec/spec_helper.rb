require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.refuse_coverage_drop
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'helium'
require 'vcr'
require 'pry'
require 'human_time/rspec_matchers'

API_KEY = (ENV['HELIUM_API_KEY'] || 'not_a_real_api_key').freeze

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f }

RSpec.configure do |c|
  c.extend Helpers
end
