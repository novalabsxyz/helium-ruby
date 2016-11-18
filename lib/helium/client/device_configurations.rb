module Helium
  class Client
    module DeviceConfigurations

      def device_configurations
        DeviceConfiguration.all(client: self)
      end

      def device_configuration(id)
        DeviceConfiguration.find(id, client: self)
      end

      def device_configuration_configuration(device_config)
        path = "/device-configuration/#{device_config.id}/configuration"
        response = get(path)
        configj = JSON.parse(response.body)["data"]
        config = Configuration.new(client: self, params: configj)
        return config
      end

      def device_configuration_device(device_config)
        path = "/device-configuration/#{device_config.id}/device"
        response = get(path)
        configj = JSON.parse(response.body)["data"]

        if configj.dig("type") == "sensor"
          device = Sensor.new(client: self, params: configj)
        elsif configj.dig("type") == "element"
          device = Element.new(client: self, params: configj)
        end

        return device
      end

      def create_device_configuration(device, configuration)
        path = "/device-configuration"

        body = {
          data: {
            type: "device-configuration",
            relationships: {
              configuration: {
                data: {
                  id: configuration.id,
                  type: configuration.type
                }
              },
              device: {
                data: {
                  id: device.id,
                  type: device.type
                }
              }
            }
          }
        }

        response = post(path, body: body)
        dc = JSON.parse(response.body)["data"]
        return DeviceConfiguration.new(client: self, params: dc)
      end

    end
  end
end
