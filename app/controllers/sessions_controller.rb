class SessionsController < ApplicationController
  def destroy
    sign_out(:user)
    redirect_to root_path
  end
end
