module Helium
  class Organization < Resource
    attr_reader :name, :timezone

    def initialize(opts = {})
      super(opts)

      @name     = @params.dig('attributes', 'name')
      @timezone = @params.dig('attributes', 'timezone')
    end

    # TODO refactor into relationships
    def users
      @client.organization_users
    end

    def labels
      @client.organization_labels
    end

    def elements
      @client.organization_elements
    end

    def sensors
      @client.organization_sensors
    end

    def as_json
      super.merge({
        name: name,
        timezone: timezone
      })
    end
  end
end
