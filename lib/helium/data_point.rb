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

    def ==(other)
      self.id == other.id
    end

    def max
      @value["max"]
    end

    def min
      @value["min"]
    end

    def avg
      @value["avg"]
    end
  end
end
