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
      return nil unless @value.is_a?(Hash)
      @value["max"]
    end

    def min
      return nil unless @value.is_a?(Hash)
      @value["min"]
    end

    def avg
      return nil unless @value.is_a?(Hash)
      @value["avg"]
    end

    def aggregate?
      [max, min, avg].none? { |agg_value| agg_value.nil? }
    end

    def as_json
      j = super.merge({
        timestamp: timestamp,
        port: port
      })

      if aggregate?
        j[:max] = max
        j[:min] = min
        j[:avg] = avg
      else
        j[:value] = value
      end

      j
    end
  end
end
