module Helium
  class Client
    module Http
      API_VERSION = 1
      HOST        = 'api.helium.com'
      PROTOCOL    = 'https'

      BASE_HTTP_HEADERS = {
        'Accept'        => 'application/json',
        'Content-Type'  => 'application/json',
        'User-Agent'    => 'helium-ruby'
      }

      def get(path = nil, url: nil, params: {})
        request = generate_request(path, url: url, method: :get, params: params)
        run(request)
      end

      def paginated_get(path, klass:, params: {})
        Cursor.new(client: self, path: path, klass: klass, params: params)
      end

      def post(path, body: {})
        request = generate_request(path, method: :post, body: body)
        run(request)
      end

      def patch(path, body: {})
        request = generate_request(path, method: :patch, body: body)
        run(request)
      end

      def delete(path)
        request = generate_request(path, method: :delete)
        response = run(request)
        response.code == 204
      end

      private

      def http_headers
        BASE_HTTP_HEADERS.merge({
          'Authorization' => api_key
        })
      end

      def generate_request(path = nil, url: nil, method:, params: {}, body: {})
        path = path.gsub(/^\//, '') if path
        url ||= "#{PROTOCOL}://#{HOST}/v#{API_VERSION}/#{path}"

        Typhoeus::Request.new(url, {
          method:   method,
          params:   params,
          headers:  http_headers,
          body:     JSON.generate(body)
        })
      end

      def run(request)
        request.run()

        if debug?
          method = request.options[:method]
          puts "#{method.upcase} #{request.url} #{request.response.code} #{request.response.total_time}"
          # puts request.response.body
        end

        # TODO error handling
        # halt(request.response.code, "Helium Get Failed: #{request.response.code.to_s}") unless request.response.code.between?(200,399)\

        return request.response
      end
    end
  end
end
