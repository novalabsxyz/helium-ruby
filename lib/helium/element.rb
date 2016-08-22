module Helium
  class Element < Resource
    attr_reader :name, :mac, :versions

    def initialize(client:, params:)
      super(client: client, params: params)

      @name     = params.dig("attributes", "name")
      @mac      = params.dig("meta", "mac")
      @versions = params.dig("meta", "versions")
    end

    # TODO these kinds of methods should be generalized into a Resource object
    def update(name:)
      @client.update_element(self, name: name)
    end
  end
end
