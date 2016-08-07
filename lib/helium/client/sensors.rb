module Helium
  class Client
    module Sensors
      def sensors
        # TODO request logic will be extracted
        url = "#{PROTOCOL}://#{HOST}/v#{API_VERSION}/sensor"
        request = Typhoeus::Request.new(url, headers: http_headers)
        request.run()
        # puts "GET #{url} #{request.response.code} #{request.response.total_time}"
        # puts request.response.body
        # halt(request.response.code, "Helium Get Failed: #{request.response.code.to_s}") unless request.response.code.between?(200,399)
        sensors_data = JSON.parse(request.response.body)["data"]

        sensors = sensors_data.map do |sensor_data|
          Sensor.new(client: self, params: sensor_data)
        end

        return sensors
      end

      def sensor(id)
        # TODO request logic will be extracted
        url = "#{PROTOCOL}://#{HOST}/v#{API_VERSION}/sensor/#{id}"
        request = Typhoeus::Request.new(url, headers: http_headers)
        request.run()
        # puts "GET #{url} #{request.response.code} #{request.response.total_time}"
        # puts request.response.body
        # halt(request.response.code, "Helium Get Failed: #{request.response.code.to_s}") unless request.response.code.between?(200,399)
        sensor_data = JSON.parse(request.response.body)["data"]

        return Sensor.new(client: self, params: sensor_data)
      end

      def sensor_timeseries(sensor, size: 1000, port: nil, start_time: nil, end_time: nil)
        # TODO request logic will be extracted
        url = "#{PROTOCOL}://#{HOST}/v#{API_VERSION}/sensor/#{sensor.id}/timeseries"

        options = {
          "page[size]" => size,
          "filter[port]" => port,
          "filter[start]" => datetime_to_iso(start_time),
          "filter[end]" => datetime_to_iso(end_time)
        }.delete_if { |key, value| value.to_s.empty? }

        request = Typhoeus::Request.new(url, {params: options, headers: http_headers})
        request.run()
        # puts "GET #{url} #{request.response.code} #{request.response.total_time}"
        # puts request.response.body
        # halt(request.response.code, "Helium Get Failed: #{request.response.code.to_s}") unless request.response.code.between?(200,399)
        timeseries_data = JSON.parse(request.response.body)["data"]

        data_points = timeseries_data.map do |data_point_data|
          DataPoint.new(client: self, params: data_point_data)
        end

        return data_points
      end
    end
  end
end
