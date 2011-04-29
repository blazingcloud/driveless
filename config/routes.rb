<<<<<<< HEAD
ActionController::Routing::Routes.draw do |map|
  devise_for :users
  map.resources :modes
=======
Rails.application.routes.draw do
  match 'robots.txt', :to => 'robots#robots_txt', :as => 'robots'
>>>>>>> f4c8989de81c88b92ecebc7a5f547d1f50a3d733

  devise_for :users

  resources :modes

  resources :baseline_trips

  resources :baselines

  resources :lengths

  resources :trips, :only => [:update, :index, :create]

  resources :units

  resources :destinations

  resources :user_sessions

  resources :users
  resource :account, :controller => "users" do
    resources :trips
    resources :groups, :except => :show
  end

  match '/account/friends', :to => 'friendships#index'
  match '/account/friends_of', :to => 'friendships#friends_of'
  match '/account/community/:id', :to => 'communities#show', :as => 'account_community'

  resources :communities

  resources :invitations, :only => [ :index, :create ]

  match 'group/:id', :to => 'groups#show', :as => 'group'
  match 'groups', :to => 'groups#index_all'

  # This is not the best way to map join and leave routes. This could be done through groups resource.
  resources :memberships, :only => [:create, :destroy]
  resources :friendships, :only => [:create, :destroy]

  match '/account/widget', :to => 'users#widget'

<<<<<<< HEAD
  match 'login' => redirect('/users/sign_in')
  match 'logout' => redirect('/users/sign_out')
  match 'register' => redirect('/users/sign_up')
  match 'privacy' => 'users#privacy'

  map.users_csv "users_csv", :controller => "users", :action => "csv"

  root :to => "home#index"
=======
  resources :password_resets

  resource :user_session

  match 'login' => redirect('/users/sign_in')
  match 'logout' => redirect('/users/sign_out')
  match 'register' => redirect('/users/sign_up')
  match 'privacy' => 'users#privacy'

  match "users_csv", :to => 'users#csv'
>>>>>>> f4c8989de81c88b92ecebc7a5f547d1f50a3d733

  root :to => "home#index"
end
