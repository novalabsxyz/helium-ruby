module Helium
  class Sensor < Resource
    attr_reader :name, :mac, :ports, :last_seen

    def initialize(opts = {})
      super(opts)

      @name      = @params.dig('attributes', 'name')
      @mac       = @params.dig('meta', 'mac')
      @ports     = @params.dig('meta', 'ports')
      @last_seen = @params.dig('meta', 'last-seen')
    end

    def element
      @client.sensor_element(self)
    end

    def self.all_path
      "/sensor?include=label"
    end

    def labels
      @client.sensor_labels(self)
    end

    def device_configuration
      @client.sensor_device_configuration(self)
    end

    def virtual?
      mac.nil?
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

    # @return [DateTime, nil] when the resource was last seen
    def last_seen
      return nil if @last_seen.nil?
      @_last_seen ||= DateTime.parse(@last_seen)
    end

    # TODO can probably generalize this a bit more
    def as_json
      super.merge({
        name: name,
        mac: mac,
        ports: ports,
        last_seen: last_seen,
        virtual: virtual?
      })
    end
  end
end
