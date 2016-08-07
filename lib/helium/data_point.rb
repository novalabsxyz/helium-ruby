module Helium
  class DataPoint
    attr_accessor :id, :timestamp, :value, :port

    def initialize(client:, params:)
      @client     = client
      @id         = params["id"]
      @timestamp  = params["attributes"]["timestamp"]
      @value      = params["attributes"]["value"]
      @port       = params["attributes"]["port"]
    end

    def timestamp
      DateTime.parse(@timestamp)
    end
  end
end
