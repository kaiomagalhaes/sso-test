module Conn
  class Connection
    REDIRECT_CODE = '302'.freeze
    YAMMER_CALLBACK_URL = ENV['YAMMER_CALLBACK_URL']

    def initialize
      @cookies = Conn::Cookies.new
      @connections = Conn::Connections
    end

    attr_reader :cookies

    def get(url, headers = {}, follow_redirect = true, cookie_names = [])
      response = get_request(url, headers, cookie_names)
      follow(response, headers, follow_redirect)
    end

    def post(url, parameters = {}, headers = {}, follow_redirect = true)
      @headers = Conn::Headers.new
      response = post_request(url, headers, parameters)
      follow(response, headers, follow_redirect)
    end

    private

    def follow(response, headers, follow_redirect)
      while redirect?(follow_redirect, response)
        response = get_request(redirect_url(response), headers)
      end
      response
    end

    def redirect?(follow_redirect, response)
      follow_redirect && response.code == REDIRECT_CODE && !redirect_url(response).include?(YAMMER_CALLBACK_URL)
    end

    def redirect_url(result)
      result['location']
    end

    def set_headers(req, headers)
      return unless headers

      headers.each do |key, value|
        req.add_field key, value
      end
    end

    def post_request(url, headers, parameters)
      @headers = Conn::Headers.new
      @headers.add(headers)
      response = @connections.post(url, updated_headers, parameters)
      after_request(response)
    end

    def get_request(url, headers = {}, cookie_names = [])
      @headers = Conn::Headers.new
      @headers.add(headers)
      response = @connections.get(url, updated_headers(cookie_names))
      after_request(response)
    end

    def after_request(response)
      @cookies.add(response)
      @headers.add(response)
      response
    end

    def updated_headers(cookie_names = [])
      @headers.add('Cookie' => @cookies.cookies(cookie_names))
      @headers.headers
    end
  end
end
