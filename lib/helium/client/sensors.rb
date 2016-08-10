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

      def sensor_timeseries(sensor, size: 1000, port: nil, start_time: nil, end_time: nil)
        options = {
          "page[size]" => size,
          "filter[port]" => port,
          "filter[start]" => datetime_to_iso(start_time),
          "filter[end]" => datetime_to_iso(end_time)
        }.delete_if { |key, value| value.to_s.empty? }

        response = get("/sensor/#{sensor.id}/timeseries", options: options)
        json_results = JSON.parse(response.body)
        timeseries_data = json_results["data"]
        timeseries_links = json_results["links"]

        return Timeseries.new(
          client: self,
          params: timeseries_data,
          links: timeseries_links
        )
      end

      def sensor_timeseries_by_link(url)
        response = get(url: url)
        json_results = JSON.parse(response.body)
        timeseries_data = json_results["data"]
        timeseries_links = json_results["links"]

        return Timeseries.new(
          client: self,
          params: timeseries_data,
          links: timeseries_links
        )
      end
    end
  end
end
