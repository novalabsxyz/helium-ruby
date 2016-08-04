module Helium
  class User
    attr_accessor :id, :name, :email, :created_at, :updated_at

    def initialize(user_data)
      @id         = user_data["id"]
      @name       = user_data["attributes"]["name"]
      @email      = user_data["meta"]["email"]
      @created_at = user_data["meta"]["created"]
      @updated_at = user_data["meta"]["updated"]
    end

    def created_at
      DateTime.parse(@created_at)
    end

    def updated_at
      DateTime.parse(@updated_at)
    end
  end
end
