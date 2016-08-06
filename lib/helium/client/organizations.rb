module Helium
  class Client
    module Organizations
      def organization
        # TODO request logic will be extracted
        url = "#{PROTOCOL}://#{HOST}/v#{API_VERSION}/organization"
        request = Typhoeus::Request.new(url, headers: http_headers)
        request.run()
        # puts "GET #{url} #{request.response.code} #{request.response.total_time}"
        # puts request.response.body
        # halt(request.response.code, "Helium Get Failed: #{request.response.code.to_s}") unless request.response.code.between?(200,399)\
        org_data = JSON.parse(request.response.body)["data"]
        return Organization.new(client: self, params: org_data)
      end

      def organization_users
        # TODO request logic will be extracted
        url = "#{PROTOCOL}://#{HOST}/v#{API_VERSION}/organization/user"
        request = Typhoeus::Request.new(url, headers: http_headers)
        request.run()
        # puts "GET #{url} #{request.response.code} #{request.response.total_time}"
        # puts request.response.body
        # halt(request.response.code, "Helium Get Failed: #{request.response.code.to_s}") unless request.response.code.between?(200,399)
        users_data = JSON.parse(request.response.body)["data"]

        users = users_data.map do |user_data|
          User.new(client: self, params: user_data)
        end

        return users
      end
    end
  end
end
