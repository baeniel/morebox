Rails.application.routes.draw do
  root 'home#index'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  resources :items
  resources :line_items
  resources :orders
end
