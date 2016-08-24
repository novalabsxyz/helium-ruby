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
        path = "/element/#{element.id}/relationships/sensor"
        response = get(path)
        sensors_data = JSON.parse(response.body)["data"]

        sensors = sensors_data.map do |sensor|
          Sensor.new(client: self, params: sensor)
        end

        return sensors
      end
    end
  end
end
