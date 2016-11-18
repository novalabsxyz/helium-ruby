module Helium
  class Configuration < Resource
    attr_reader :settings

    def initialize(opts = {})
      super(opts)
      @settings = @params.dig('attributes')
    end


  end
end
