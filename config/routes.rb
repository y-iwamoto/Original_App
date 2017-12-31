Rails.application.routes.draw do

  resources :notification, only:[:show,:update,:destroy,:index]

  devise_for :users, controllers: { registrations: 'registrations' ,
  omniauth_callbacks: "omniauth_callbacks"}
  get 'home/index'

  get 'home/SpotImg'
  post 'post' => 'introduction#post'
  resources :introduction, only:[:index]
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: "home#index"
  namespace :api, { format: 'json' } do
    namespace :v1 do
        resources :schedule_each_date
    end
  end

  resources :travel_planning, only:[:create,:new,:edit,:update,:destroy,:index]
  resources :travel_planning_date, only:[:index]
  get 'travel_planning_date/upload' => 'travel_planning_date#upload_prepare'
  post 'travel_planning_date/upload' =>  'travel_planning_date#upload'
  patch 'travel_planning_date/upload' =>  'travel_planning_date#upload'
  get 'travel_planning_date/upload_prepare'
  resources :travel_planning_time, only:[:show,:update]do
    collection do
      get :show_spot_roting
    end
  end

  resources :spot_search, :only => [ :index, :show, :create, :destroy ] do
    collection do
      get :list
      get :getImg
      get :favorite_spot_list
    end
    member do
      get :select
      get :favorite_create
    end
  end

end
