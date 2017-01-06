module Helium
  class Client
    module Organizations
      def organization
        response = get('/organization')
        org_data = JSON.parse(response.body)["data"]
        return Organization.new(client: self, params: org_data)
      end
    end
  end
end
