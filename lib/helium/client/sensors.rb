module Helium
  class Client
    module Sensors
      def sensors
        Sensor.all(client: self)
      end

      def sensor(id)
        Sensor.find(id, client: self)
      end

      def sensor_timeseries(sensor, opts = {})
        path = "/sensor/#{sensor.id}/timeseries"

        params = {
          "page[size]"    => opts.fetch(:size, nil),
          "filter[port]"  => opts.fetch(:port, nil),
          "filter[start]" => datetime_to_iso(opts.fetch(:start_time, nil)),
          "filter[end]"   => datetime_to_iso(opts.fetch(:end_time, nil)),
          "agg[type]"     => opts.fetch(:aggtype),
          "agg[size]"     => opts.fetch(:aggsize)
        }.delete_if { |_key, value| value.to_s.empty? }

        paginated_get(path, klass: Helium::DataPoint, params: params)
      end

      # TODO refactor data points/timeseries to be proper resources
      def sensor_create_timeseries(sensor, opts= {})
        path = "/sensor/#{sensor.id}/timeseries"
        resource_name = 'data-point'

        attributes = {
          port: opts.fetch(:port),
          value: opts.fetch(:value),
          timestamp: datetime_to_iso(opts.fetch(:timestamp))
        }

        body = {
          data: {
            attributes: attributes,
            type: resource_name
          }
        }

        response = post(path, body: body)
        resource_data = JSON.parse(response.body)["data"]

        return DataPoint.new(client: self, params: resource_data)
      end

      def create_sensor(attributes)
        Sensor.create(attributes, client: self)
      end
    end
  end
end
