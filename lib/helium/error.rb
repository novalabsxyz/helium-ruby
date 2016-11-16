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
      # Default the error message in the case of no error body
      message = "Unknown error with code: #{response.code.to_s}"
      message = JSON.parse(response.body)["errors"].first["detail"] if response.body && response.body.length >= 2

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
