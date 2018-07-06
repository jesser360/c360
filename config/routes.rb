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

  resources :users do
      member do
        get :confirm_email
      end
    end

  get '/combine_duplicates/:token' => 'user_orders#combine_duplicates', as: 'combine_duplicates'
  get '/user_order_search' => 'user_orders#search'
  get '/find_previous_orders' => 'user_orders#find_previous_orders'
  get '/user_order/show_buy_now/:token' => 'user_orders#show_buy_now', as: 'user_order_buy_now_path'
  get '/users_supplier/:token' => 'users#show_supplier', as: 'user_supplier_path'

  get '/users/:token', to: 'users#show', as: 'user_path'
  get '/signup' => 'users#new'
  get '/users/edit/:token', to: 'users#edit', as: 'edit_user_path'
  patch '/users/update/:token', to: 'users#update', as: 'update_user_path'
  get '/signup' => 'users#new'
  post '/signup' => 'users#create'

  root 'bulk_orders#index'
  get '/home' => 'pages#home'
  get '/store' => 'bulk_orders#index'
  get '/about' => 'pages#about'
  get '/services' => 'pages#services'
  get '/info' => 'pages#info'

  post '/bid/publish/:id' => 'bids#publish', as: 'publish_bid_path'


  post '/bulk_order/publish/:token' => 'bulk_orders#publish', as: 'publish_bulk_order_path'
  get '/bulk_order/seller/edit/:token' => 'bulk_orders#seller_edit', as: 'seller_edit_bulk_order_path'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'

end
