module Helium
  # Custom error class for rescuing from Helium API errors
  class Error < StandardError

    # Returns the appropriate Helium::Error subclass based on status and
    # response message
    #
    # @param [Typhoeus::Response] response
    # @return [Helium::Error]
    def self.from_response(response)
      status  = response.code
      message = JSON.parse(response.body)["errors"].first["detail"]

      klass =  case status
               when 401   then Helium::InvalidApiKey
               else self
               end

      klass.new(message)
    end
  end

  # Raised on errors in the 400-499 range
  class ClientError < Error; end

  # Raised when Helium returns a 401 error
  class InvalidApiKey < ClientError; end
end
