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

      def get(path, opts = {})
        run(path, :get, opts)
      end

      def paginated_get(path, opts = {})
        klass  = opts.fetch(:klass)
        params = opts.fetch(:params, {})

        Cursor.new(client: self, path: path, klass: klass, params: params)
      end

      def post(path, opts = {})
        run(path, :post, opts)
      end

      def patch(path, opts = {})
        run(path, :patch, opts)
      end

      def delete(path)
        response = run(path, :delete)
        response.code == 204
      end

      private

      def http_headers
        BASE_HTTP_HEADERS.merge({
          'Authorization' => api_key
        })
      end

      def run(path, method, opts = {})
        request = generate_request(path, opts.merge(method: method))
        response = run_request(request)
        return response
      end

      def generate_request(path, opts = {})
        method = opts.fetch(:method)
        params = opts.fetch(:params, {})
        body   = opts.fetch(:body, {})


        url = if path =~ /^http/
          path
        else
          path = path.gsub(/^\//, '')
          "#{PROTOCOL}://#{HOST}/v#{API_VERSION}/#{path}"
        end

        Typhoeus::Request.new(url, {
          method:   method,
          params:   params,
          headers:  http_headers,
          body:     JSON.generate(body)
        })
      end

      def run_request(request)
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
