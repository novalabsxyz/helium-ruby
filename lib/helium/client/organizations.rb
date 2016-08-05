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
        return Organization.new(org_data)
      end
    end
  end
end
