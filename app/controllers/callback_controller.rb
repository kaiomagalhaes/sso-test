class CallbackController < ApplicationController
  def index
    access_key = ENV['APP_KEY']
    secret_key = ENV['APP_SECRET']

    token_url = "#{ENV['APP_URL']}/oauth/token"
    token_params = {
      client_id: access_key,
      client_secret: secret_key,
      code: params[:code]
    }

    token_result = Conn::Connection.new.post(token_url, token_params)
    token = JSON.parse(token_result.body)['access_token']
    user_url = "#{ENV['APP_URL']}/api/user"
    user = Conn::Connection.new.get(user_url, {'Authorization' => "Bearer #{token}"})

    respond_to do |format|
      format.json { render json: JSON.parse(user.body)}
    end
  end

  def fetch(uri, limit=10)
    resource_uri = URI(uri)
    http = Net::HTTP.new(resource_uri.hostname, resource_uri.port)
    response = http.get(resource_uri, headers)
    case response
    when Net::HTTPSuccess then
      response
    when Net::HTTPRedirection then
      fetch(response['location'], limit - 1)
    else
      response
    end
  end
end
