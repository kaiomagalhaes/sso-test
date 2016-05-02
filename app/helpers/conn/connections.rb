module Conn
  class Connections
    def self.get(url, headers = {})
      uri = URI(url)
      conn(uri).get(uri, headers)
    end

    def self.post(url, headers = {}, parameters = {})
      uri = URI(url)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data(parameters)
      set_headers(request, headers)
      conn(uri).request(request)
    end

    def self.conn(uri)
      http = Net::HTTP.new(uri.hostname, uri.port)
      http.use_ssl = uri.scheme == 'https'
      http
    end

    def self.set_headers(req, headers)
      return unless headers

      headers.each do |key, value|
        req.add_field key, value
      end
    end
  end
end
