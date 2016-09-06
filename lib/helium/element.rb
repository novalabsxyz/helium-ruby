module Helium
  class Element < Resource
    attr_reader :name, :mac, :last_seen

    def initialize(opts = {})
      super(opts)

      @name      = @params.dig("attributes", "name")
      @mac       = @params.dig("meta", "mac")
      @last_seen = @params.dig('meta', 'last-seen')
    end

    def sensors
      @client.element_sensors(self)
    end

    # @return [DateTime, nil] when the resource was last seen
    def last_seen
      return nil if @last_seen.nil?
      @_last_seen ||= DateTime.parse(@last_seen)
    end

    # TODO can probably generalize this a bit more
    def as_json
      super.merge({
        name: name,
        mac: mac,
        last_seen: last_seen
      })
    end
  end
end
