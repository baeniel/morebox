Rails.application.routes.draw do
  post 'apis/pay_url'
  root 'home#index'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  resources :items
  resources :line_items do
    member do
      get 'reduce'
    end
  end
  resources :orders do
    member do
      get 'payment'
      get 'request_order'
      get 'complete'
    end
  end
  get 'home/policy'
end
