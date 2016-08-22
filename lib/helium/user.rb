module Helium
  class User < Resource
    attr_reader :name, :email

    def initialize(client:, params:)
      super(client: client, params: params)

      @name  = params.dig('attributes', 'name')
      @email = params.dig('meta', 'email')
    end

    # TODO can probably generalize this a bit more
    def as_json
      super.merge({
        name: name,
        email: email
      })
    end
  end
end
