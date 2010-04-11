class HomeController < ApplicationController
  def index
    if current_user
      redirect_to current_user
    end
  end

end
