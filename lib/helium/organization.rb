module Helium
  class Organization < Resource
    attr_reader :name, :timezone

    def initialize(opts = {})
      client = opts.fetch(:client)
      params = opts.fetch(:params)
      
      super(client: client, params: params)

      @name     = params.dig('attributes', 'name')
      @timezone = params.dig('attributes', 'timezone')
    end

    # TODO refactor into relationships
    def users
      @client.organization_users
    end

    def as_json
      super.merge({
        name: name,
        timezone: timezone
      })
    end
  end
end
