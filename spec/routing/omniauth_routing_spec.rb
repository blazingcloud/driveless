require 'spec_helper'

describe SessionsController do

  it 'routes /sign_out' do
    {:get => '/sign_out'}.should route_to(:controller => 'sessions', :action => 'destroy')
  end

  it 'routes /users/auth/twitter/callback' do
    {:get => '/users/auth/twitter/callback'}.should route_to(
        :controller => 'omniauth_callbacks', :action => 'twitter')
  end
end
