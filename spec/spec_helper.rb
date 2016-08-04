require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'helium'
require 'vcr'
require 'pry'

API_KEY = ENV['HELIUM_API_KEY'] || 'not_a_real_api_key'

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f }
