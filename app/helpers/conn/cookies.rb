module Conn
  class Cookies
    COOKIES_SEPARATOR = '; '.freeze

    def initialize
      @cookies = {}
    end

    def cookies(names)
      list = @cookies.collect do |k, v|
        "#{k}=#{v}" if names.empty? || names.include?(k)
      end
      list.compact.join(COOKIES_SEPARATOR)
    end

    def add(response)
      all_cookies = response.get_fields('set-cookie') || []
      all_cookies.each do |cookie|
        current_cookie = cookie.split(COOKIES_SEPARATOR)[0]
        key = current_cookie[/(.*?)=.*/, 1]
        value = current_cookie[/=(.*$)/, 1]
        @cookies[key] = value
      end
    end
  end
end
