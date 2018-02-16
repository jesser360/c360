Rails.application.routes.draw do
  resources :user_orders
  resources :bulk_orders
  resources :items
  resources :charges


  get '/' => 'sessions#new'
  get '/items' => 'items#index'

  get '/users/:id', to: 'users#show', as: 'user_path'
  get '/signup' => 'users#new'
  get '/users/edit/:id', to: 'users#edit', as: 'edit_user_path'
  patch '/users/update/:id', to: 'users#update', as: 'update_user_path'
  post '/signup' => 'users#create'
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'

end
