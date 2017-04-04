module Helium
  class Label < Resource
    attr_reader :name

    def initialize(opts = {})
      super(opts)

      @name = @params.dig("attributes", "name")
    end

    def sensors
      Collection.new(klass: Sensor, client: @client, belongs_to: self)
    end

    def add_sensors(sensors_to_add = [])
      sensors.add_relationships(sensors_to_add)
      self
    end

    def replace_sensors(sensors_to_replace = [])
      sensors.replace_relationships(sensors_to_replace)
      self
    end

    def remove_sensors(sensors_to_remove = [])
      sensors.remove_relationships(sensors_to_remove)
      self
    end

    def elements
      Collection.new(klass: Element, client: @client, belongs_to: self)
    end

    def add_elements(elements_to_add = [])
      elements.add_relationships(elements_to_add)
      self
    end

    def replace_elements(elements_to_replace = [])
      elements.replace_relationships(elements_to_replace)
      self
    end

    def remove_elements(elements_to_remove = [])
      elements.remove_relationships(elements_to_remove)
      self
    end

    # TODO can probably generalize this a bit more
    def as_json
      super.merge({
        name: name
      })
    end
  end
end
