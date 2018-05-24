Rails.application.routes.draw do
  namespace :admin do
    resources :bulk_orders
    resources :emails
    resources :items
    resources :users
    resources :user_orders
    resources :order_items

    root to: "bulk_orders#index"
  end

  resources :user_orders, :except => [:index]
  resources :bulk_orders, :except => [:destroy]
  resources :items
  resources :charges
  resources :emails
  resources :bids
  resources :bid_offers
  resources :reviews

  root 'pages#home'
  get '/home' => 'pages#home'
  get '/store' => 'bulk_orders#index'
  get '/about' => 'pages#about'
  get '/services' => 'pages#services'


  post '/bulk_order/publish/:id' => 'bulk_orders#publish', as: 'publish_bulk_order_path'
  get '/bulk_order/seller/edit/:id' => 'bulk_orders#seller_edit', as: 'seller_edit_bulk_order_path'

  get '/user_order/show_buy_now/:id' => 'user_orders#show_buy_now', as: 'user_order_buy_now_path'
  get '/users_supplier/:id' => 'users#show_supplier', as: 'user_supplier_path'

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
