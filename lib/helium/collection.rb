module Helium
  class Collection
    include Enumerable

    attr_reader :filter_criteria

    def initialize(opts)
      @client     = opts.fetch(:client)
      @klass      = opts.fetch(:klass)
      @belongs_to = opts.fetch(:belongs_to, nil)

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
    # @param [Hash] criteria a set of search criteria
    #
    # @example Search for sensors by location
    #   client.sensors.where(location: 'Building B') #=> [Sensor, Sensor]
    #
    # @example Search for multiple matching search parameters
    #   client.sensors.where(departments: ['it', 'engineering']) #=> [Sensor, Sensor]
    #
    # @return [Collection] a collection of resources matching the provided search criteria
    def where(criteria)
      add_filter_criteria(criteria)
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

    # TODO: could support something like label.sensors << new_sensor
    # see Label#add_sensors for where it would be applied
    def +(other)
      collection + other
    end

    def -(other)
      collection - other
    end

    def [](index)
      collection[index]
    end

    # Collections are considered equal if they contain the same resources
    # as determined by the resources' ids
    def ==(other)
      self.map(&:id).sort == other.map(&:id).sort
    end

    # NOTE: if we implement pagination, we'll need to rethink this
    def last
      collection.last
    end

    # Adds resources of the same type to the collection related to the
    # '@belongs_to' resource
    def add_relationships(items)
      body = relationship_request_body(items)
      @client.post(relationship_path, body: body)
    end

    # Replaces resources of the same type to the collection related to the
    # '@belongs_to' resource. An empty array removes all resources.
    def replace_relationships(items)
      body = relationship_request_body(items)
      @client.patch(relationship_path, body: body)
    end

    # Removes resources of the same type to the collection related to the
    # '@belongs_to' resource. An empty array removes all resources.
    def remove_relationships(items)
      body = relationship_request_body(items)
      @client.delete(relationship_path, body: body)
    end

    protected

    def add_filter_criteria(criteria)
      criteria.each do |key, value|
        if existing_value = @filter_criteria[key]
          @filter_criteria[key] = (Array(existing_value) + Array(value)).uniq
        else
          @filter_criteria[key] = value
        end
      end
    end

    def fetch_collection
      response = @client.get(resource_path)
      return collection_from_response(response)
    end

    def filter_param
      "filter[metadata]=#{@filter_criteria.to_json}"
    end

    def resource_path
      uri = if @belongs_to
              URI.parse("#{@belongs_to.resource_path}/#{@klass.resource_name}")
            else
              URI.parse(@klass.all_path)
            end

      if @filter_criteria.any?
        uri.query = [uri.query, filter_param].compact.join('&')
      end

      uri.to_s
    end

    def relationship_path
      if @belongs_to
        URI.parse("#{@belongs_to.resource_path}/relationships/#{@klass.resource_name}").to_s
      else
        raise Helium::Error.new(
          "The collection must be associated with a resource to modify the
          relationship")
      end
    end

    def collection_from_response(response)
      resources_data = JSON.parse(response.body)["data"]

      resources = resources_data.map do |resource_data|
        @klass.new(client: @client, params: resource_data)
      end

      return resources
    end

    def relationship_request_body(items)
      items = Array(items)
      if items.all? {|item| item.is_a? @klass }
        new_items_data = items.map do |item|
          {
            id: item.id,
            type: "#{@klass.resource_name}"
          }
        end
        { data: new_items_data }
      else
        raise Helium::Error.new(
          "All items added to the collection must be of type " + @klass.to_s)
      end

    end

  end
end
