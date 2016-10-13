module Helium
  class Client
    module Organizations
      def organization
        response = get('/organization')
        org_data = JSON.parse(response.body)["data"]
        return Organization.new(client: self, params: org_data)
      end

      def organization_users
        response = get('/organization/user')
        users_data = JSON.parse(response.body)["data"]

        users = users_data.map do |user_data|
          User.new(client: self, params: user_data)
        end

        return users
      end

      def organization_labels
        response = get('/organization/label')
        labels_data = JSON.parse(response.body)["data"]

        labels = labels_data.map do |label_data|
          Label.new(client: self, params: label_data)
        end

        return labels
      end

      def organization_elements
        response = get('/organization/element')
        elements_data = JSON.parse(response.body)["data"]

        elements = elements_data.map do |element_data|
          Element.new(client: self, params: element_data)
        end

        return elements
      end

      def organization_sensors
        response = get('/organization/sensor')
        sensors_data = JSON.parse(response.body)["data"]

        sensors = sensors_data.map do |sensor_data|
          Sensor.new(client: self, params: sensor_data)
        end

        return sensors
      end
    end
  end
end
