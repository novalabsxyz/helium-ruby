require 'helium/client/users'
require 'helium/client/organizations'
require 'helium/client/sensors'

module Helium
  class Client
    include Helium::Utils
    include Helium::Client::Users
    include Helium::Client::Organizations
    include Helium::Client::Sensors

    API_VERSION = 1
    HOST        = 'api.helium.com'
    PROTOCOL    = 'https'

    BASE_HTTP_HEADERS = {
      'Accept'        => 'application/json',
      'Content-Type'  => 'application/json',
      'User-Agent'    => 'helium-ruby'
    }

    attr_accessor :api_key

    def initialize(api_key:)
      @api_key = api_key
    end

    def http_headers
      BASE_HTTP_HEADERS.merge({
        'Authorization' => api_key
      })
    end
  end
end
