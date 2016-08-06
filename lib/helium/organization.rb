module Helium
  class Organization
    attr_accessor :id, :name, :timezone, :created_at, :updated_at

    def initialize(client:, params:)
      @client     = client
      @id         = params["id"]
      @name       = params["attributes"]["name"]
      @timezone   = params["attributes"]["timezone"]
      @created_at = params["meta"]["created"]
      @updated_at = params["meta"]["updated"]
    end

    def created_at
      DateTime.parse(@created_at)
    end

    def updated_at
      DateTime.parse(@updated_at)
    end

    # TODO refactor into relationships
    def users
      @client.organization_users
    end
  end
end
