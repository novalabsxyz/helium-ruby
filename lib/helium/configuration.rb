module Helium
  class Configuration < Resource
    attr_reader :settings

    def initialize(opts = {})
      super(opts)
      @settings = @params.dig('attributes')
    end

    def device_configurations
      @client.config_device_configurations(self.id)
    end

  end
end
