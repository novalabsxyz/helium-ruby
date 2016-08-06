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
    end
  end
end
