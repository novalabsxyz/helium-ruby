module Helium
  class User < Resource
    attr_reader :name, :email

    def initialize(client:, params:)
      super(client: client, params: params)

      @name  = params.dig('attributes', 'name')
      @email = params.dig('meta', 'email')
    end
  end
end
