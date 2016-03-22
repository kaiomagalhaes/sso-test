class HomeController < ApplicationController
  def index
    access_key = ENV['APP_KEY']
    secret_key = ENV['APP_SECRET']

    @toSend = {
        'secret_key' => secret_key,
        'access_key' => access_key,
        'callback_url' => "#{ENV['APP_URL']}/api/sessions/validate"
    }.to_json

    uri = URI.parse("#{ENV['APP_URL']}/api/sessions")
    https = Net::HTTP.new(uri.host,uri.port)
    req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})
    req.body = "#{@toSend}"
    res = https.request(req)

    @SIGN_IN_URL = JSON.parse(res.body)['redirect_url']
  end
end
