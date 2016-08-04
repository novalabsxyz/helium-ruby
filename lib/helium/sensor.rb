module Helium
  class Sensor
    attr_accessor :id, :name, :mac, :ports, :created_at, :updated_at

    def initialize(sensor_data)
      @id         = sensor_data["id"]
      @name       = sensor_data["attributes"]["name"]
      @mac        = sensor_data["meta"]["mac"]
      @ports      = sensor_data["meta"]["ports"]
      @created_at = sensor_data["meta"]["created"]
      @updated_at = sensor_data["meta"]["updated"]
    end

    def created_at
      DateTime.parse(@created_at)
    end

    def updated_at
      DateTime.parse(@updated_at)
    end
  end
end
