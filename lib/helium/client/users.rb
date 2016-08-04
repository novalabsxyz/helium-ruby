module Helium
  class Client
    module Users
      def user
        # TODO request logic will be extracted
        url = "#{PROTOCOL}://#{HOST}/v#{API_VERSION}/user"
        request = Typhoeus::Request.new(url, headers: http_headers)
        request.run()
        # puts "GET #{url} #{request.response.code} #{request.response.total_time}"
        # puts request.response.body
        # halt(request.response.code, "Helium Get Failed: #{request.response.code.to_s}") unless request.response.code.between?(200,399)\
        user_data = JSON.parse(request.response.body)["data"]
        return User.new(user_data)
      end
    end
  end
end
