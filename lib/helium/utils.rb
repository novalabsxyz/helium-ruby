module Helium
  module Utils
    def datetime_to_iso(datetime)
      return nil if datetime.nil?
      Time.parse(datetime.to_s).utc.iso8601
    end
  end
end
