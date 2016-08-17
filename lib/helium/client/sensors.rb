module Helium
  class Client
    module Sensors
      def sensors
        response = get('/sensor')
        sensors_data = JSON.parse(response.body)["data"]

        sensors = sensors_data.map do |sensor_data|
          Sensor.new(client: self, params: sensor_data)
        end

        return sensors
      end

      def sensor(id)
        response = get("/sensor/#{id}")
        sensor_data = JSON.parse(response.body)["data"]

        return Sensor.new(client: self, params: sensor_data)
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
        }.delete_if { |key, value| value.to_s.empty? }

        paginated_get(path, klass: Helium::DataPoint, params: params)
      end

      def new_sensor(name:)
        path = "/sensor"

        body = {
          data: {
            attributes: {
              name: name
            },
            type: "sensor"
          }
        }

        response = post(path, body: body)
        sensor_data = JSON.parse(response.body)["data"]

        return Sensor.new(client: self, params: sensor_data)
      end

      def delete_sensor(sensor)
        path = "/sensor/#{sensor.id}"
        delete(path)
      end

    end
  end
end
