module Helium
  class Client
    module Elements
      def elements
        Element.all(client: self)
      end

      def element(id)
        Element.find(id, client: self)
      end

      def element_sensors(element)
        path = "/element/#{element.id}?include=sensor"
        response = get(path)
        sensors_data = JSON.parse(response.body)["included"]

        sensors = sensors_data.map do |sensor|
          Sensor.new(client: self, params: sensor)
        end

        return sensors
      end

      def element_timeseries(element, opts = {})
        path = "/element/#{element.id}/timeseries"

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
      def element_create_timeseries(element, opts= {})
        path = "/element/#{element.id}/timeseries"
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
    end
  end
end
