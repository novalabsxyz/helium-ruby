module Helium
  # TODO make Metadata inherit from Resource and implement method_missing
  # for all resources to automatically generate methods for attributes
  # rather than whitelisting them with hardcoding
  class Metadata
    def initialize(opts = {})
      @client = opts.fetch(:client)
      @klass  = opts.fetch(:klass)

      @params = fetch_params
    end

    def id
      @klass.id
    end

    def properties
      @params["attributes"]
    end

    def inspect
      "<Helium::Metadata properties=#{properties}>"
    end

    def method_missing(method_name, *arguments, &block)
      properties[method_name.to_s] || super
    end

    def respond_to_missing?(method_name, include_private = false)
      properties[method_name.to_s] || super
    end

    def update(attributes = {})
      body = {
        data: {
          attributes: attributes,
          id: id,
          type: "metadata"
        }
      }

      response = @client.patch(path, body: body)
      @params = JSON.parse(response.body)["data"]
      return self
    end

    protected

    def path
      "#{@klass.resource_path}/metadata"
    end

    def fetch_params
      response = @client.get(path)
      JSON.parse(response.body)["data"]
    end
  end
end
