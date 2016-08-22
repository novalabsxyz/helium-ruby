module Helium
  class Organization < Resource
    attr_reader :name, :timezone

    def initialize(client:, params:)
      super(client: client, params: params)

      @name     = params.dig('attributes', 'name')
      @timezone = params.dig('attributes', 'timezone')
    end

    # TODO refactor into relationships
    def users
      @client.organization_users
    end
  end
end
