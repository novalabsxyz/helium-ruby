module Helium
  class Organization
    attr_accessor :id, :name, :timezone, :created_at, :updated_at

    def initialize(org_data)
      @id         = org_data["id"]
      @name       = org_data["attributes"]["name"]
      @timezone   = org_data["attributes"]["timezone"]
      @created_at = org_data["meta"]["created"]
      @updated_at = org_data["meta"]["updated"]
    end

    def created_at
      DateTime.parse(@created_at)
    end

    def updated_at
      DateTime.parse(@updated_at)
    end
  end
end
