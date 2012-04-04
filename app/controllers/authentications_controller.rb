class AuthenticationsController < ApplicationController
  def create
    omniauth = request.env["omniauth.auth"]

    if(authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid']))
      # If authentication exists, log in the user
      #
      sign_in_and_redirect(:user, authentication.user)

    elsif current_user
      # If user is logged in and authentication doesn't exist, create the authentication
      #
      current_user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
      redirect_to edit_user_path(current_user)
    else
      # if no current user - create a new user and an authentication for the user
      #
      user = User.connect_via_omniauth(omniauth)
      sign_in(user)
      redirect_to edit_account_path
    end
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    redirect_to edit_user_path(current_user)
  end
end
