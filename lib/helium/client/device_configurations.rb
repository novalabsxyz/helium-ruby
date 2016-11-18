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
        if configj.type == "sensor"
          device = Sensor.new(client: self, params: configj)
        elsif configj.type == "element"
          device = Element.new(client: self, params: configj)
        end

        return device
      end

    end
  end
end
