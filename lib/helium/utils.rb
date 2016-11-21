module Helium
  module Utils
    def datetime_to_iso(datetime)
      return nil if datetime.nil?
      Time.parse(datetime.to_s).utc.iso8601
    end

    def kebab_case(string)
      string.gsub(/(.)([A-Z])/,'\1-\2').downcase
    end
  end
end
