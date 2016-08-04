require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'helium'
require 'vcr'

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f }
