module Helium
  # Abstract base class for Helium Resources returned by the API
  class Resource
    attr_reader :id

    def initialize(client:, params:)
      @client     = client
      @id         = params["id"]
      @created_at = params.dig('meta', 'created')
      @updated_at = params.dig('meta', 'updated')
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
        created_at: created_at,
        updated_at: updated_at
      }
    end

    # @return [String] a JSON-encoded String representing the resource
    def to_json(*options)
      as_json.to_json(*options)
    end
  end
end
