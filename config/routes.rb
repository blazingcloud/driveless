Rails.application.routes.draw do
  match 'robots.txt', :to => 'robots#robots_txt', :as => 'robots'

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
    resources :groups, :except => :show do
      post :merge, :on => :member
    end
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

  resources :password_resets

  resource :user_session

  match 'login' => redirect('/users/sign_in')
  match 'logout' => redirect('/users/sign_out')
  match 'register' => redirect('/users/sign_up')
  match 'privacy' => 'users#privacy'

  match "users_csv", :to => 'users#csv'

  match "results" => "results#index"

  root :to => "home#index"
end
