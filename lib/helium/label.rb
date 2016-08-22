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

    # TODO: would be nice to wrap this in a proxy collection, that way
    # we could do something like label.sensors << new_sensor
    def sensors
      @client.label_sensors(self)
    end

    def add_sensors(sensors_to_add = [])
      sensors_to_add = Array(sensors_to_add)

      @client.update_label_sensors(self, sensors: sensors + sensors_to_add)
    end

    def remove_sensors(sensors_to_remove = [])
      sensors_to_remove = Array(sensors_to_remove)

      @client.update_label_sensors(self, sensors: sensors - sensors_to_remove)
    end
  end
end
