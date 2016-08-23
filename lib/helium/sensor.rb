module Helium
  class Sensor < Resource
    attr_reader :name, :mac, :ports

    def initialize(opts = {})
      super(opts)

      @name  = @params.dig('attributes', 'name')
      @mac   = @params.dig('meta', 'mac')
      @ports = @params.dig('meta', 'ports')
    end

    def timeseries(opts = {})
      size        = opts.fetch(:size, 1000)
      port        = opts.fetch(:port, nil)
      start_time  = opts.fetch(:start_time, nil)
      end_time    = opts.fetch(:end_time, nil)
      aggtype     = opts.fetch(:aggtype, nil)
      aggsize     = opts.fetch(:aggsize, nil)

      @client.sensor_timeseries(self,
        size:       size,
        port:       port,
        start_time: start_time,
        end_time:   end_time,
        aggtype:    aggtype,
        aggsize:    aggsize
      )
    end

    # TODO can probably generalize this a bit more
    def as_json
      super.merge({
        name: name,
        mac: mac,
        ports: ports
      })
    end
  end
end
