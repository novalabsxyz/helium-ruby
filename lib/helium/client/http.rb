module Helium
  class Client
    module Http
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
        cursor_klass  = opts.fetch(:cursor_klass, Helium::Cursor)
        params = opts.fetch(:params, {})

        cursor_klass.new(client: self, path: path, klass: klass, params: params)
      end

      def post(path, opts = {})
        run(path, :post, opts)
      end

      def patch(path, opts = {})
        run(path, :patch, opts)
      end

      def put(path, opts = {})
        run(path, :put, opts)
      end

      def delete(path)
        response = run(path, :delete)
        response.code == 204
      end

      def base_url
        url = "#{PROTOCOL}://#{@api_host}"
        url += "/#{@api_version}" if @api_version
        url
      end

      # Contructs a proper url given a path. If the path is already a full url
      # it will simply pass through
      def url_for(path)
        return path if path =~ /^http/

        path = path.gsub(/^\//, '')
        "#{base_url}/#{path}"
      end

      private

      def http_headers
        BASE_HTTP_HEADERS
          .merge(@headers)
          .merge({
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
        url    = url_for(path)

        Typhoeus::Request.new(url, {
          method:         method,
          params:         params,
          headers:        http_headers,
          ssl_verifypeer: @verify_peer,
          body:           JSON.generate(body)
        })
      end

      def run_request(request)
        request.run()

        response = request.response

        if debug?
          method = request.options[:method]
          puts "#{method.upcase} #{request.url} #{request.response.code} #{request.response.total_time}"
          # puts request.response.body
        end

        halt(response) unless response.code.between?(200,399)

        return response
      end

      def halt(response)
        raise Helium::Error.from_response(response)
      end
    end
  end
end
