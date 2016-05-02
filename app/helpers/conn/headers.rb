module Conn
  class Headers
    def initialize
      @headers = {}
    end

    attr_reader :headers

    def add(response)
      response.to_hash.each do |k, v|
        @headers[k] = v.class == Array ? v.first : v
      end
    end
  end
end
