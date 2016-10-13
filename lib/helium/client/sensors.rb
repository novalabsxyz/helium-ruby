module Helium
  class Client
    module Sensors
      def sensors
        Sensor.all(client: self)
      end

      def sensor(id)
        Sensor.find(id, client: self)
      end

      def sensor_element(sensor)
        path = "/sensor/#{sensor.id}/element"
        response = get(path)
        elementj = JSON.parse(response.body)["data"]
        element = Element.new(client: self, params: elementj)

        return element
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

        paginated_get(path,
          klass:        Helium::DataPoint,
          cursor_klass: Helium::Timeseries,
          params:       params
        )
      end

      def create_sensor(attributes)
        Sensor.create(attributes, client: self)
      end
    end
  end
end
