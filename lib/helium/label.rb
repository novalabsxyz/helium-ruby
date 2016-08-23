module Helium
  class Label < Resource
    attr_reader :name

    def initialize(opts = {})
      super(opts)

      @name = @params.dig("attributes", "name")
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

    # TODO can probably generalize this a bit more
    def as_json
      super.merge({
        name: name
      })
    end
  end
end
