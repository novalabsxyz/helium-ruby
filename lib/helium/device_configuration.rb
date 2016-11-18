module Helium
  class DeviceConfiguration < Resource
    attr_reader :loaded

    def initialize(opts = {})
      super(opts)
      @loaded = @params.dig('meta', 'loaded')
    end

    def device
      @client.device_configuration_device(self)
    end

    def configuration
      @client.device_configuration_configuration(self)
    end

    def as_json
      super.merge({ loaded: loaded })
    end

  end
end
