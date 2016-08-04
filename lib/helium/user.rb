module Helium
  class User
    attr_accessor :id, :name, :email, :created_at, :updated_at

    def initialize(json)
      json_data = JSON.parse(json)["data"]

      @id         = json_data["id"]
      @name       = json_data["attributes"]["name"]
      @email      = json_data["meta"]["email"]
      @created_at = json_data["meta"]["created"]
      @updated_at = json_data["meta"]["updated"]
    end

    def created_at
      DateTime.parse(@created_at)
    end

    def updated_at
      DateTime.parse(@updated_at)
    end
  end
end
