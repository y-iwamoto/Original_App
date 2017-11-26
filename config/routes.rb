Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root 'travel_planning#index'

  namespace :api, { format: 'json' } do
    namespace :v1 do
        resources :schedule_each_date
    end
  end

  resources :travel_planning, only:[:create,:new,:edit,:update,:destroy,:index]
  resources :travel_planning_date, only:[:index]
  resources :travel_planning_time, only:[:show,:update]

  resources :spot_search, :only => [ :index, :show, :create, :destroy ] do
    collection do
      get :list
    end
    member do
      get :select
    end
  end

end
