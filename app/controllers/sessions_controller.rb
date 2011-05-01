class SessionsController < ApplicationController

  def create
    sign_in(:user)
    redirect_to root_path
  end

  def destroy
    sign_out(:user)
    redirect_to root_path
  end
end
