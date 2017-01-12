module Helium
  class Client
    module Configurations

      def configurations
        Configuration.all(client: self)
      end

      def configuration(id)
        Configuration.find(id, client: self)
      end

      # Configurations are immutable, so no updates are available
      def create_configuration(attributes)
        Configuration.create(attributes, client: self)
      end
    end
  end
end
