module Helium
  class Client
    module Users
      def user
        User.singleton(client: self)
      end
    end
  end
end
