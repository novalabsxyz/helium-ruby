module Helium
  class Sensor
    attr_accessor :id, :name, :mac, :ports, :created_at, :updated_at

    def initialize(client:, params:)
      @client     = client
      @id         = params["id"]
      @name       = params["attributes"]["name"]
      @mac        = params["meta"]["mac"]
      @ports      = params["meta"]["ports"]
      @created_at = params["meta"]["created"]
      @updated_at = params["meta"]["updated"]
    end

    def created_at
      DateTime.parse(@created_at)
    end

    def updated_at
      DateTime.parse(@updated_at)
    end
  end
end
