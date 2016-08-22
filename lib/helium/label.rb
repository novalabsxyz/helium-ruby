module Helium
  class Label
    attr_accessor :id, :name, :created_at, :updated_at

    def initialize(client:, params:)
      @client     = client
      @id         = params["id"]
      @name       = params.dig("attributes", "name")
      @created_at = params.dig("meta", "created")
      @updated_at = params.dig("meta", "updated")
    end

    def created_at
      @_created_at ||= DateTime.parse(@created_at)
    end

    def updated_at
      @_updated_at ||= DateTime.parse(@updated_at)
    end

    def update(name:)
      @client.update_label(self, name: name)
    end

    def destroy
      @client.delete_label(self)
    end
  end
end
