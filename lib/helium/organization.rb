module Helium
  class Organization < Resource
    attr_reader :name, :timezone

    def initialize(opts = {})
      super(opts)

      @name     = @params.dig('attributes', 'name')
      @timezone = @params.dig('attributes', 'timezone')
    end

    def resource_path
      "/organization"
    end

    # TODO refactor into relationships
    def users
      Collection.new(klass: User, client: @client, belongs_to: self)
    end

    def labels
      Collection.new(klass: Label, client: @client, belongs_to: self)
    end

    def elements
      Collection.new(klass: Element, client: @client, belongs_to: self)
    end

    def sensors
      Collection.new(klass: Sensor, client: @client, belongs_to: self)
    end

    def as_json
      super.merge({
        name: name,
        timezone: timezone
      })
    end
  end
end
