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
      if @content
        @content
      else
        response = @client.get(resource_path+'/content',
                               content_type: 'application/octet-stream')
        @content = response.body
      end
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
      if @content
        @content
      else
        response = @client.get(resource_path+'/content',
                               content_type: 'application/octet-stream')
        @content = response.body
      end
    end
  end

  class Package < Resource
    attr_reader :name

    def initialize(opts = {})
      super(opts)
      @name = @params.dig('attributes', 'name')
    end

    def script
      Script.initialize_from_path(path: "#{resource_path}/script", client: @client)
    end

    def libraries
      Collection.new(klass: Library, client: @client, belongs_to: self)
    end
  end

  class SensorPackage < Resource
    attr_reader :loaded

    def initialize(opts = {})
      super(opts)
      @loaded = @params.dig('meta', 'loaded')
    end

    def sensor
      Sensor.initialize_from_path(path: "#{resource_path}/sensor", client: @client)
    end

    def package
      Package.initialize_from_path(path: "#{resource_path}/package", client: @client)
    end
  end
end
