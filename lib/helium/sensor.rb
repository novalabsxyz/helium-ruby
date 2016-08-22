module Helium
  class Sensor < Resource
    attr_reader :name, :mac, :ports

    def initialize(client:, params:)
      super(client: client, params: params)

      @name  = params.dig('attributes', 'name')
      @mac   = params.dig('meta', 'mac')
      @ports = params.dig('meta', 'ports')
    end

    def timeseries(size: 1000, port: nil, start_time: nil, end_time: nil, aggtype: nil, aggsize: nil)
      @client.sensor_timeseries(self,
        size:       size,
        port:       port,
        start_time: start_time,
        end_time:   end_time,
        aggtype:    aggtype,
        aggsize:    aggsize
      )
    end

    # TODO these kinds of methods should be generalized into a Resource object
    def update(name:)
      @client.update_sensor(self, name: name)
    end

    def destroy
      @client.delete_sensor(self)
    end
  end
end
