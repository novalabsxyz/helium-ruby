# The following classes are all closely related and thus included in the same file
module Helium
  class Script < Resource
    attr_reader :name

    def initialize(opts = {})
      super(opts)
      @name    = @params.dig('attributes', 'name')
      @digest  = @params.dig('meta', 'digest')
    end

    def content
      @content ||= @client.get(resource_path+'/content',
                               content_type: 'application/octet-stream').body
    end
  end

  class Library < Resource
    attr_reader :name

    def initialize(opts = {})
      super(opts)
      @name   = @params.dig('attributes', 'name')
      @digest = @params.dig('meta', 'digest')
    end

    def content
      @content ||= @client.get(resource_path+'/content',
                               content_type: 'application/octet-stream').body
    end
  end

  class Package < Resource
    attr_reader :name

    def initialize(opts = {})
      super(opts)
      @name = @params.dig('attributes', 'name')
    end

    # Script is immutable and can be cached
    def script
      @script ||= Script.initialize_from_path(path: "#{resource_path}/script",
                                               client: @client)
    end

    # Libraries are immutable and can be cached
    def libraries
      @libs ||= Collection.new(klass: Library, client: @client,
                               belongs_to: self)
    end
  end

  class SensorPackage < Resource
    attr_reader :loaded

    def initialize(opts = {})
      super(opts)
      @loaded = @params.dig('meta', 'loaded')
    end

    # Sensor is not immutable (name can change), and should not be cached
    def sensor
      Sensor.initialize_from_path(path: "#{resource_path}/sensor", client: @client)
    end

    # Package is immutable and can be cached
    def package
      @package ||= Package.initialize_from_path(path: "#{resource_path}/package",
                                                client: @client)
    end
  end
end
