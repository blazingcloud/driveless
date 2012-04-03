class AuthenticationsController < ApplicationController
  def create
    omniauth = request.env["omniauth.auth"]

    # If authentication exists, log in the user
    if(authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid']))
      sign_in_and_redirect(:user, authentication.user)

    # If user is logged in and authentication doesn't exist, create the authentication
    else
      current_user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
      redirect_to edit_user_path(current_user)
    end
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    redirect_to edit_user_path(current_user)
  end
end
