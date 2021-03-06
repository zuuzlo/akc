Rails.application.routes.draw do
  
  get 'comments/new'

  get 'comments/create'

  #devise_for :users

  devise_for :users, :controllers => { registrations: 'registrations' }
  
  root to: 'coupons#index'

  #resources :users #, only: [:show]

  resources :coupons, only: [:index, :show] do
    member do
      get 'coupon_link'
      get 'reveal_code_link'
      get 'add_comment'
      get 'hide_comment'
    end

    collection do
      get 'search', to: 'coupons#search'
      get 'tab_all'
      get 'tab_coupon_codes'
      get 'tab_offers'
    end

    resources :comments do
      member do
        get 'reveal_comment'
      end
    end
  end

  resources :comments do
    resources :comments
  end

  resources :kohls_categories, only: [:show]
  resources :kohls_types, only: [:show]
  resources :kohls_onlies, only: [:show]

  namespace :admin do
    resources :coupons, only: [:index, :new, :create, :edit, :update, :destroy]
    get 'get_kohls_coupons', to: 'coupons#get_kohls_coupons'
    get 'delete_kohls_coupons', to: 'coupons#delete_kohls_coupons'
    get 'get_mailer_kohls_coupons', to: 'coupons#get_mailer_kohls_coupons'
    get 'get_keywords', to: 'coupons#get_keywords'
  end

  #get '/pages/*id' => 'pages#show', as: :page, format: false,  path: '*id'
end
