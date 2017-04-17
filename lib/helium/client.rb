require 'helium/client/configurations'
require 'helium/client/device_configurations'
require 'helium/client/elements'
require 'helium/client/helium_scripts'
require 'helium/client/http'
require 'helium/client/labels'
require 'helium/client/organizations'
require 'helium/client/sensors'
require 'helium/client/users'

module Helium
  class Client
    include Helium::Utils
    include Helium::Client::Configurations
    include Helium::Client::DeviceConfigurations
    include Helium::Client::Elements
    include Helium::Client::HeliumScripts
    include Helium::Client::Http
    include Helium::Client::Labels
    include Helium::Client::Organizations
    include Helium::Client::Sensors
    include Helium::Client::Users


    API_VERSION = 'v1'
    HOST        = 'api.helium.com'
    PROTOCOL    = 'https'

    attr_accessor :api_key

    def initialize(opts = {})
      @api_key     = opts.fetch(:api_key)
      @api_host    = opts.fetch(:host, HOST)
      @api_version = opts.fetch(:api_version, API_VERSION)
      @verify_peer = opts.fetch(:verify_peer, true)
      @debug       = opts.fetch(:debug, false)
      @headers     = opts.fetch(:headers, {})
    end

    def inspect
      "<Helium::Client @debug=#{@debug}>"
    end

    def debug?
      @debug == true
    end
  end
end
