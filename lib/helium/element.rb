module Helium
  class Element < Resource
    attr_reader :name, :mac, :versions

    def initialize(client:, params:)
      super(client: client, params: params)

      @name     = params.dig("attributes", "name")
      @mac      = params.dig("meta", "mac")
      @versions = params.dig("meta", "versions")
    end

    # TODO can probably generalize this a bit more
    def as_json
      super.merge({
        name: name,
        mac: mac,
        versions: versions
      })
    end
  end
end
