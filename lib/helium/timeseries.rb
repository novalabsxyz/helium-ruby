module Helium
  class Timeseries < Cursor
    include Helium::Utils

    # Creates a new data point on this timeseries
    # @option opts [String] :port A port for the data point
    # @option opts [String] :value A value for the data point
    # @option opts [DateTime] :timestamp A timestamp for the data point. If not provided, it will default to the current time.
    # @return [DataPoint]
    def create(opts = {})
      port      = opts.fetch(:port)
      value     = opts.fetch(:value)
      timestamp = opts.fetch(:timestamp, DateTime.now)

      body = {
        data: {
          attributes: {
            port:      port,
            value:     value,
            timestamp: datetime_to_iso(timestamp)
          },
          type: 'data-point'
        }
      }

      response = @client.post(@path, body: body)
      resource_data = JSON.parse(response.body)["data"]

      return DataPoint.new(client: self, params: resource_data)
    end

  end
end
