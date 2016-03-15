class HomeController < ApplicationController
  def index
    @SIGN_IN_URL = ENV['APP_SIGN_IN_URL']
  end
end
