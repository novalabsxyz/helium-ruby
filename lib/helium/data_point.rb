module Helium
  class DataPoint < Resource
    attr_reader :timestamp, :value, :port

    def initialize(client:, params:)
      super(client: client, params: params)

      @timestamp  = params.dig("attributes", "timestamp")
      @value      = params.dig("attributes", "value")
      @port       = params.dig("attributes", "port")
    end

    def timestamp
      DateTime.parse(@timestamp)
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
