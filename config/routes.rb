Hungrlr::Application.routes.draw do
  require 'resque/server'
  mount Resque::Server.new, :at => "/resque"

  namespace "api" do ## Used for Ajax purposes
    namespace "v1" do
      get '/feeds/:display_name' => 'feeds#show'
      post '/feeds/:display_name' => 'feeds#create'
      resources :user_tweets, only: [:create, :index]
      resources :meta_data, :only => [ :create ]
    end
  end

  namespace "api" do
    namespace "v1" do
      resources :meta_data, only: [ :create ]
      post '/feeds/:display_name/growls/:id/refeed' => 'feeds#refeed'
    end
  end
  constraints(Subdomain) do
    constraints :subdomain => 'api' do ## For external use
      scope module: "api" do
        namespace "v1" do
          get    '/validate_token' => 'api#validate_token'
          get    '/users/twitter' => 'users#twitter'
          get    '/users/github' => 'users#github'
          get    '/users/instagram' => 'users#instagram'
          get    '/feeds/:display_name' => 'feeds#show'
          get    '/feeds/:display_name/growls/:id' => 'growls#show', as: :growl
          get    '/feeds/:display_name/growls' => 'growls#index'
          post   '/feeds/:display_name/growls' => 'growls#create'
          delete '/feeds/:display_name/growls' => 'growls#destroy'
          post   '/feeds/:display_name/growls/:id/refeed' => 'feeds#refeed'
          delete '/feeds/:display_name/growls/:id/refeed' => 'feeds#destroy_refeed'
          post   '/feeds/:display_name/refeeds' => 'feeds#subscriber_refeed'
          resources :user_tweets, only: [:create, :index]
          resources :user_github_events, only: [:create, :index]
          resources :user_instagram_photos, only: [:create, :index]
          resources :meta_data, :only => [ :create ]
          resources :subscriptions, :only => [:index]
        end
      end
    end
    match '/' => 'growls#index', as: :user_feed
  end
  match "/home" => "pages#home"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    get '/signup' => 'devise/registrations#new'
    get '/login' => 'devise/sessions#new'
  end

  resources :growls, :only => [ :show, :create ] do
    post 'points', on: :member
  end
  resources :regrowled, only: [:create]
  resources :authentications, :only => [ :new, :destroy ]
  resources :images
  resources :links
  resources :messages
  resource :dashboard, :only => [ :show ]
  resources :subscriptions, :only => [:index, :create, :destroy]
  resource :search do
    get 'display_names'
  end
  match "/trending_topics" => "topics#index"

  root :to => 'pages#home'
end
