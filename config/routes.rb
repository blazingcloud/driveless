ActionController::Routing::Routes.draw do |map|
  map.resources :modes

  map.resources :baseline_trips

  map.resources :baselines

  map.resources :lengths

  map.resources :trips, { :only => [:update, :index, :create] }

  map.resources :units

  map.resources :destinations

  map.resources :user_sessions

  map.resources :users
  map.resource :account, :controller => "users" do |account_map|
    account_map.resources :trips
    account_map.resources :groups, :except => :show
    account_map.friends 'friends', :controller => 'friendships'
    account_map.friends_of 'friends_of', :controller => 'friendships', :action => 'friends_of'
    account_map.community 'community/:id', :controller => 'communities', :action => 'show'
  end

  map.resources :communities

  map.group 'group/:id', :controller => 'groups', :action => 'show'
  map.groups 'groups', :controller => 'groups', :action => 'index_all'

  # This is not the best way to map join and leave routes. This could be done through groups resource.
  map.resources :memberships, :only => [:create, :destroy]
  map.resources :friendships, :only => [:create, :destroy]

  map.connect '/account/widget', :controller => "users", :action => "widget"

  map.resources :password_resets

  map.resource :user_session

  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.register "register", :controller => "users", :action => "new"

  map.root :controller => "user_sessions", :action => "new"

  map.resources :messages,  
                   :collection => {:destroy_selected => :post,  
                                   :inbox            => :get,  
                                   :outbox           => :get,  
                                   :trashbin         => :get},  
                   :member => {:reply => :get}  


  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
