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
    end
  end
end
