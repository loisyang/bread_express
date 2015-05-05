BreadExpress::Application.routes.draw do

  # Routes for main resources
  resources :addresses
  resources :customers
  resources :orders
  resources :items
  resources :sessions
  resources :users
  resources :item_prices
  resources :carts

  # Authentication routes
  get 'cart/newCartItem' => 'carts#newCartItem', as: :newCartItem_cart
  get 'cart' => 'carts#show'
  get 'cart/show' => 'carts#show', as: :show_current_cart
  post 'cart/show' => 'carts#clear'
  delete 'cart/show' => 'carts#destory'
  put 'cart/show' => 'carts#add'
  get 'cart/edit' => 'carts#edit', as: :edit_current_cart  
  get 'user/edit' => 'users#edit', as: :edit_current_user
  get 'customer/new' => 'customers#new', as: :signup
  get 'logout' => 'sessions#destroy', as: :logout
  get 'login' => 'sessions#new', as: :login

  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy
  get 'search' => 'home#search', as: :search
  get 'cylon' => 'errors#cylon', as: :cylon
  
  # Set the root url
  root :to => 'home#home'  
  
  # Named routes
  get 'item/index' => 'item#index'

  # Last route in routes.rb that essentially handles routing errors
  get '*a', to: 'errors#routing'
end
