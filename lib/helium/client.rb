require 'helium/client/http'
require 'helium/client/users'
require 'helium/client/organizations'
require 'helium/client/sensors'
require 'helium/client/elements'

module Helium
  class Client
    include Helium::Utils
    include Helium::Client::Http
    include Helium::Client::Users
    include Helium::Client::Organizations
    include Helium::Client::Sensors
    include Helium::Client::Elements

    attr_accessor :api_key

    def initialize(api_key:, debug: false)
      @api_key = api_key
      @debug = debug
    end

    def inspect
      "<Helium::Client @debug=#{@debug}>"
    end

    def debug?
      @debug == true
    end
  end
end
