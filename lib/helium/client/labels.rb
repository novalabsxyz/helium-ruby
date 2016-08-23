module Helium
  class Client
    module Labels
      def labels
        Label.all(client: self)
      end

      def label(id)
        Label.find(id, client: self)
      end

      def create_label(attributes)
        Label.create(attributes, client: self)
      end

      def update_label(label, name:)
        path = "/label/#{label.id}"

        body = {
          data: {
            attributes: {
              name: name
            },
            id: label.id,
            type: "label"
          }
        }

        response = patch(path, body: body)
        label_data = JSON.parse(response.body)["data"]

        return Label.new(client: self, params: label_data)
      end

      def label_sensors(label)
        path = "/label/#{label.id}/sensor"
        response = get(path)
        sensors_data = JSON.parse(response.body)["data"]

        sensors = sensors_data.map do |sensor_data|
          Sensor.new(client: self, params: sensor_data)
        end

        return sensors
      end

      def update_label_sensors(label, sensors: [])
        path = "/label/#{label.id}/relationships/sensor"

        sensors = Array(sensors)

        new_sensor_data = sensors.map do |sensor|
          {
            id: sensor.id,
            type: 'sensor'
          }
        end

        body = {
          data: new_sensor_data
        }

        response = patch(path, body: body)
        sensors_data = JSON.parse(response.body)["data"]

        # TODO: these come back deflated. need to either inflate at this point or
        # when needed
        sensors = sensors_data.map do |sensor_data|
          Sensor.new(client: self, params: sensor_data)
        end

        return sensors
      end
    end
  end
end
