module Helium
  class Client
    module Organizations
      def organization
        Organization.singleton(client: self)
      end
    end
  end
end
