module Helium
  class Client
    module Users
      def user
        response = get('/user')
        user_data = JSON.parse(response.body)["data"]
        return User.new(client: self, params: user_data)
      end
    end
  end
end
