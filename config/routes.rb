routes = lambda do
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
    post '/login' => 'user_sessions#create', :as => :create_new_session
    get '/logout' => 'user_sessions#destroy', :as => :logout
    get '/signup' => 'user_registrations#new', :as => :signup
    post '/signup' => 'user_registrations#create', :as => :registration
    get '/password/recover' => 'user_passwords#new', :as => :recover_password
    post '/password/recover' => 'user_passwords#create', :as => :reset_password
    get '/password/change' => 'user_passwords#edit', :as => :edit_password
    put '/password/change' => 'user_passwords#update', :as => :update_password
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

if Spree::Core::Engine.respond_to?(:add_routes)
  Spree::Core::Engine.add_routes(&routes)
else
  Spree::Core::Engine.routes.draw(&routes)
end