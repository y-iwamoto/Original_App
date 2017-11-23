Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root 'travel_planning#index'
  # ここから追記
  namespace :api, { format: 'json' } do
    namespace :v1 do
        resources :schedule_each_date
    end
  end
# 追記終了
  resources :travel_planning, only:[:create,:new,:edit,:update,:destroy,:index]
  resources :travel_planning_date, only:[:index,:create]
end
