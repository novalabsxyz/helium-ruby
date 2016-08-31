require 'helium/client/http'
require 'helium/client/users'
require 'helium/client/organizations'
require 'helium/client/sensors'
require 'helium/client/labels'
require 'helium/client/elements'

module Helium
  class Client
    include Helium::Utils
    include Helium::Client::Http
    include Helium::Client::Users
    include Helium::Client::Organizations
    include Helium::Client::Sensors
    include Helium::Client::Labels
    include Helium::Client::Elements

    attr_accessor :api_key

    def initialize(opts = {})
      @api_key  = opts.fetch(:api_key)
      @api_host = opts.fetch(:host, nil)
      @debug    = opts.fetch(:debug, false)
    end

    def inspect
      "<Helium::Client @debug=#{@debug}>"
    end

    def debug?
      @debug == true
    end
  end
end
