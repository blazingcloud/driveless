ActionController::Routing::Routes.draw do |map|
  map.resources :modes

  map.resources :baseline_trips

  map.resources :baselines

  map.resources :lengths

  #map.resources :trips

  map.resources :units

  map.resources :destinations

  map.resources :user_sessions

  map.resource :account, :controller => "users" do |account_map|
    account_map.resources :trips
  end

  map.resource :communities

  map.connect '/account/widget', :controller => "users", :action => "widget"

  map.resources :users

  map.resource :user_session

  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.register "register", :controller => "users", :action => "new"

  map.root :controller => "users", :action => "new"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
