Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root 'travel_planning#index'
  get "travel_planning_time/change_spot_ary" => 'travel_planning_time#change_spot_ary'
  namespace :api, { format: 'json' } do
    namespace :v1 do
        resources :schedule_each_date
    end
  end

  resources :travel_planning, only:[:create,:new,:edit,:update,:destroy,:index]
  resources :travel_planning_date, only:[:index]
  resources :travel_planning_time, only:[:show,:update]do
    collection do
      get :show_spot_roting
    end
  end

  resources :spot_search, :only => [ :index, :show, :create, :destroy ] do
    collection do
      get :list
    end
    member do
      get :select
      get :favorite_create
    end
  end

end
