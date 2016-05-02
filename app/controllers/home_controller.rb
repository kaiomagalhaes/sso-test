class HomeController < ApplicationController
  def index
    access_key = ENV['APP_KEY']
    secret_key = ENV['APP_SECRET']
    redirect_uri = 'http://localhost:5000/callback'

    uri = URI.parse("#{ENV['APP_URL']}/oauth/authorize?client_id=#{access_key}&secret_key=#{secret_key}&redirect_uri=#{redirect_uri}")
    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE # read into this
    res = https.get(uri.to_s)
    redirect_to res['location']
  end
end
