module Helium
  class Collection
    include Enumerable

    def initialize(opts)
      @client = opts.fetch(:client)
      @klass  = opts.fetch(:klass)

      @filter_criteria = {}
    end

    # Returns all resources
    # @option opts [Client] :client A Helium::Client
    # @return [Helium::Collection] a Collection of all of the given Resource
    def all
      @filter_criteria = {}
      self
    end

    # Uses metadata filtering
    # (https://docs.helium.com/api/v1/metadata/index.html#filtering)
    # to search for a collection of resources matching the search parameters
    # @param [Hash] a set of search criteria
    #
    # @example Search for sensors by location
    #   client.sensors.where(location: 'Building B') #=> [Sensor, Sensor]
    #
    # @example Search for multiple matching search parameters
    #   client.sensors.where(departments: ['it', 'engineering']) #=> [Sensor, Sensor]
    #
    # @return [Collection] a Collection of resources matching the provided search criteria
    def where(criteria)
      @filter_criteria.merge!(criteria)
      self
    end

    # Returns an array of the Resources belonging to the Collection
    # @return [Resource]
    def collection
      fetch_collection
    end

    def each
      collection.each{ |element| yield element }
    end

    def inspect
      collection
    end

    def to_json(*options)
      collection.to_json(*options)
    end

    protected

    def fetch_collection
      response = @client.get(resource_path)
      return collection_from_response(response)
    end

    def filter_param
      "filter[metadata]=#{@filter_criteria.to_json}"
    end

    def resource_path
      uri = URI.parse(@klass.all_path)
      if @filter_criteria.any?
        uri.query = [uri.query, filter_param].compact.join('&')
      end
      uri.to_s
    end

    def collection_from_response(response)
      resources_data = JSON.parse(response.body)["data"]

      resources = resources_data.map do |resource_data|
        @klass.new(client: @client, params: resource_data)
      end

      return resources
    end

  end
end
