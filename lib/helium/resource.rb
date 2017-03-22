module Helium
  # Abstract base class for Helium Resources returned by the API
  class Resource
    attr_reader :id, :type, :params
    include Helium::Utils

    def initialize(opts = {})
      @client = opts.fetch(:client)
      @params = opts.fetch(:params)

      @id         = @params["id"]
      @type       = @params.dig('type')
      @created_at = @params.dig('meta', 'created')
      @updated_at = @params.dig('meta', 'updated')
    end

    class << self
      include Helium::Utils

      # The resource's index API route
      # @return [String] path to resource's index
      def all_path
        "/#{resource_name}"
      end

      def all(opts = {})
        client = opts.fetch(:client)
        Collection.new(klass: self, client: client).all
      end

      # Finds a single Resource by id
      # @param id [String] An id to find the Resource
      # @option opts [Client] :client A Helium::Client
      # @return [Resource]
      def find(id, opts = {})
        client = opts.fetch(:client)
        initialize_from_path(path: "/#{resource_name}/#{id}", client: client)
      end

      # Fetches a singleton resource (e.g. organization, user)
      # @option opts [Client] :client A Helium::Client
      # @return [Resource] A singleton resource
      def singleton(opts = {})
        client = opts.fetch(:client)
        initialize_from_path(path: all_path, client: client)
      end

      # Creates a new resource with given attributes
      # @param attributes [Hash] The attributes for the new Resource
      # @option opts [Client] :client A Helium::Client
      # @return [Resource]
      def create(attributes, opts = {})
        client = opts.fetch(:client)

        path = "/#{resource_name}"

        body = {
          data: {
            attributes: attributes,
            type: resource_name
          }
        }

        response = client.post(path, body: body)
        resource_data = JSON.parse(response.body)["data"]

        return self.new(client: client, params: resource_data)
      end

      def resource_name
        kebab_case(self.name.split('::').last)
      end

      def initialize_from_path(opts = {})
        client = opts.fetch(:client)
        path = opts.fetch(:path)

        response = client.get(path)
        resource_data = JSON.parse(response.body)["data"]
        return self.new(client: client, params: resource_data)
      end
    end # << self

    # Returns a path identifying the current resource. Can be overridden
    # in child classes to handle non-standard resources (e.g. Organization)
    # @return [String] path to resource
    def resource_path
      "/#{resource_name}/#{self.id}"
    end

    # Updates a Resource
    # @param attributes [Hash] The attributes to update
    # @return [Resource] The updated resource
    def update(attributes)
      body = {
        data: {
          attributes: attributes,
          id: self.id,
          type: resource_name
        }
      }

      response = @client.patch(resource_path, body: body)
      resource_data = JSON.parse(response.body)["data"]

      return self.class.new(client: @client, params: resource_data)
    end

    # Deletes the Resource
    # @return [Boolean] Whether the operation was successful
    def destroy
      @client.delete(resource_path)
    end

    def metadata
      Metadata.new(client: @client, klass: self)
    end

    # Override equality to use id for comparisons
    # @return [Boolean]
    def ==(other)
      self.id == other.id
    end

    # Override equality to use id for comparisons
    # @return [Boolean]
    def eql?(other)
      self == other
    end

    # Override equality to use id for comparisons
    # @return [Integer]
    def hash
      id.hash
    end

    # @return [DateTime, nil] when the resource was created
    def created_at
      return nil if @created_at.nil?
      @_created_at ||= DateTime.parse(@created_at)
    end

    # @return [DateTime, nil] when the resource was last updated
    def updated_at
      return nil if @updated_at.nil?
      @_updated_at ||= DateTime.parse(@updated_at)
    end

    # Inheriting resources should implement this with super
    # @return [Hash] a Hash of the object's attributes for JSON
    def as_json
      {
        id: id,
        type: type,
        created_at: created_at,
        updated_at: updated_at
      }
    end

    # @return [String] a JSON-encoded String representing the resource
    def to_json(*options)
      as_json.to_json(*options)
    end

    def resource_name
      kebab_case(self.class.name.split('::').last)
    end
  end
end
