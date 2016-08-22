module Helium
  class Label < Resource
    attr_reader :name

    def initialize(client:, params:)
      super(client: client, params: params)

      @name = params.dig("attributes", "name")
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
