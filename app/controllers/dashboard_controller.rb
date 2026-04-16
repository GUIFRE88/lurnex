class DashboardController < ApplicationController
  def index
    redirect_to after_authentication_url
  end
end
