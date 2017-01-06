module Helium
  class Configuration < Resource
    attr_reader :settings

    def initialize(opts = {})
      super(opts)
      @settings = @params.dig('attributes')
    end

    def device_configurations
      Collection.new(
        klass: DeviceConfiguration,
        client: @client,
        belongs_to: self
      )
    end

  end
end
