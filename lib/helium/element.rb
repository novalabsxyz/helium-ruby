module Helium
  class Element
    attr_accessor :id, :name, :mac, :created_at, :updated_at, :versions
    def initialize(client:, params:)
      @client     = client
      @id         = params["id"]
      @name       = params.dig("attributes", "name")
      @mac        = params.dig("meta", "mac")
      @created_at = params.dig("meta", "created")
      @updated_at = params.dig("meta", "updated")
      @versions   = params.dig("meta", "versions")
    end

    def created_at
      @_created_at ||= DateTime.parse(@created_at)
    end

    def updated_at
      @_updated_at ||= DateTime.parse(@updated_at)
    end

    # TODO these kinds of methods should be generalized into a Resource object
    def update(name:)
      @client.update_element(self, name: name)
    end
  end
end
