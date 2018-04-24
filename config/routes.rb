Rails.application.routes.draw do
  namespace :admin do
    resources :bulk_orders
    resources :emails
    resources :items
    resources :users
    resources :user_orders

    root to: "bulk_orders#index"
  end

  resources :user_orders, :except => [:index]
  resources :bulk_orders, :except => [:index,:destroy]
  resources :items, :except => [:show]
  resources :charges
  resources :emails

  root 'pages#home'
  get '/home' => 'pages#home'
  get '/items' => 'items#index'
  get '/home' => 'pages#home'
  get '/about' => 'pages#about'
  get '/services' => 'pages#services'

  get '/users/:id', to: 'users#show', as: 'user_path'
  get '/signup' => 'users#new'
  get '/users/edit/:id', to: 'users#edit', as: 'edit_user_path'
  patch '/users/update/:id', to: 'users#update', as: 'update_user_path'
  get '/signup' => 'users#new'
  post '/signup' => 'users#create'
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'

end
