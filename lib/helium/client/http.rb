module Helium
  class Client
    module Http
      BASE_HTTP_HEADERS = {
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

      # Stream data from the provided path
      # @param [String] path a relative path
      # @option opts [Class] :klass a class to be initialized with received data
      # @option opts [Hash] :params a hash of params to be used as query params
      # @block
      def stream_from(path, opts = {}, &block)
        klass = opts.fetch(:klass)
        params = opts.fetch(:params, {})
        request = generate_request(path, {
          method: :get,
          content_type: :stream,
          params: params
        })

        request.on_body do |chunk|
          if chunk =~ /data:/
            json_string = chunk[chunk.index('{')..chunk.rindex('}')]
            json_data = JSON.parse(json_string)["data"]
            object = klass.new(client: self, params: json_data)
            yield object
          end
        end

        run_request(request)
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

      def http_headers(opts = {})
        content_type = opts.fetch(:content_type, :json)

        http_headers = BASE_HTTP_HEADERS
          .merge(@headers)
          .merge({
            'Authorization' => api_key
          })

        case content_type
        when :json
          http_headers.merge!({
            'Accept'        => 'application/json',
            'Content-Type'  => 'application/json'
          })
        when :stream
          http_headers.merge!({
            'Accept'        => 'text/event-stream',
            'Content-Type'  => 'text/event-stream'
          })
        end

        return http_headers
      end

      def run(path, method, opts = {})
        request = generate_request(path, opts.merge(method: method))
        response = run_request(request)
        return response
      end

      def generate_request(path, opts = {})
        method       = opts.fetch(:method)
        content_type = opts.fetch(:content_type, :json)
        params       = opts.fetch(:params, {})
        body         = opts.fetch(:body, {})
        url          = url_for(path)

        Typhoeus::Request.new(url, {
          method:         method,
          params:         params,
          headers:        http_headers(content_type: content_type),
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
