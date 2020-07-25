Rails.application.routes.draw do
  get 'users/pay_complete'
  root 'products#marketing'
  get 'home/index'
  post 'apis/pay_url'
  post 'apis/pay_complete'

  get 'home/exception'
  get 'home/policy'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations', passwords: 'users/passwords', confirmations: 'users/confirmations' }
  resources :items, only: [:index, :show] do
    collection do
      get 'auto_out'
      get :list
    end
  end
  resources :line_items, only: [:update, :create, :destroy] do
    member do
      get 'reduce'
    end
  end
  resources :orders, only: [:update, :index, :show] do
    collection do
      get :payment
    end
  end

  resources :users do
    member do
      post :pay_complete
    end
  end
  resources :gyms
  resources :points


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
