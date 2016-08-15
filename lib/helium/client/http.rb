module Helium
  class Client
    module Http
      def get(path = nil, url: nil, options: {})
        path = path.gsub(/^\//, '') if path
        url ||= "#{PROTOCOL}://#{HOST}/v#{API_VERSION}/#{path}"

        request = Typhoeus::Request.new(url, {
          params: options,
          headers: http_headers
        })

        run(request)
      end

      private

      def run(request)
        request.run()

        if debug?
          # TODO print request method dynamically, won't always be GET
          puts "GET #{request.url} #{request.response.code} #{request.response.total_time}"
          # puts request.response.body
        end

        # TODO error handling
        # halt(request.response.code, "Helium Get Failed: #{request.response.code.to_s}") unless request.response.code.between?(200,399)\

        return request.response
      end
    end
  end
end
