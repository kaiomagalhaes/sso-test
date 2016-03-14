class CallbackController < ApplicationController
  def index
    r = fetch("https://sso-test-codelitt.azurewebsites.net/api/user?token=#{params[:token]}")
    respond_to do |format|
      format.json { render json:  r.body}
    end
  end

  def fetch(uri, limit=10)
    resource_uri = URI(uri)
    http = Net::HTTP.new(resource_uri.hostname, resource_uri.port)
    http.use_ssl = limit == 10
    response = http.get(resource_uri, headers)
    case response
      when Net::HTTPSuccess then
        response
      when Net::HTTPRedirection then
        fetch(response['location'], limit - 1)
      else
        response.error!
    end
  end
end
