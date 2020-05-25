Rails.application.routes.draw do
  post 'apis/pay_url'
  root 'home#index'
  get 'home/exception'
  get 'home/policy'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations', passwords: 'users/passwords', confirmations: 'users/confirmations' }
  resources :items, only: [:index, :show] do
    collection do
      get 'auto_out'
    end
  end
  resources :line_items, only: [:update, :create] do
    member do
      get 'reduce'
    end
  end
  resources :orders, only: [:update, :index, :show]
  resources :gyms


  #모어박스 쇼핑몰 구조
  # post 'apis/pay_url'
  # root 'home#index'
  # devise_for :admin_users, ActiveAdmin::Devise.config
  # ActiveAdmin.routes(self)
  # devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations', passwords: 'users/passwords', confirmations: 'users/confirmations' }
  # resources :items
  # resources :line_items do
  #   member do
  #     get 'reduce'
  #   end
  # end
  # resources :orders do
  #   member do
  #     get 'payment'
  #     get 'request_order'
  #     get 'complete'
  #   end
  # end
  # resources :comments
  # get 'home/policy'
  # get 'home/faq'
  ##################
end
