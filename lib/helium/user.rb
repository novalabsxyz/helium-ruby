module Helium
  class User < Resource
    attr_reader :name, :email, :pending_invite
    alias_method :pending_invite?, :pending_invite

    def initialize(opts = {})
      super(opts)

      @name           = @params.dig('attributes', 'name')
      @email          = @params.dig('meta', 'email')
      @pending_invite = @params.dig('meta', 'pending_invite')
    end

    # TODO can probably generalize this a bit more
    def as_json
      super.merge({
        name: name,
        email: email,
        pending_invite: pending_invite
      })
    end
  end
end
