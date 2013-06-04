Spree::Core::Engine.routes.draw do
  devise_for :spree_user,
             :class_name => 'Spree::User',
             :controllers => { :sessions => 'spree/user_sessions',
                               :registrations => 'spree/user_registrations',
                               :passwords => 'spree/user_passwords' },
             :skip => [:unlocks, :omniauth_callbacks],
             :path_names => { :sign_out => 'logout' },
             :path_prefix => :user

  resources :users, :only => [:edit, :update]

  devise_scope :spree_user do
    get '/login' => 'user_sessions#new', :as => :login
    get '/logout' => 'user_sessions#destroy', :as => :logout
    get '/signup' => 'user_registrations#new', :as => :signup
  end

  get '/checkout/registration' => 'checkout#registration', :as => :checkout_registration
  put '/checkout/registration' => 'checkout#update_registration', :as => :update_checkout_registration

  resource :session do
    member do
      get :nav_bar
    end
  end

  resource :account, :controller => 'users'

  namespace :admin do
    resources :users
  end
end
