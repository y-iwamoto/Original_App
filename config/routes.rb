Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root 'travel_planning#index'
  resources :travel_planning, only:[:create,:new,:edit,:update,:destroy,:index]
end
