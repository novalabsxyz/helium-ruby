module Helium
  class Client
    module Configurations

      def configurations
        Configuration.all(client: self)
      end

      def configuration(id)
        Configuration.find(id, client: self)
      end

      def config_device_configurations(id)
        path = "/configuration/#{id}/device-configuration"
        response = get(path)
        device_confs_data = JSON.parse(response.body)["data"]

        device_confs = device_confs_data.map do |dc|
          DeviceConfiguration.new(client: self, params: dc)
        end

        return device_confs
      end

      # Configurations are immutable, so no updates are available
      def create_configuration(attributes)
        Configuration.create(attributes, client: self)
      end
    end
  end
end
