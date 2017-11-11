Rails.application.routes.draw do
  root 'travel_planning#index'
  resources :travel_planning, only:[:create,:new,:edit,:update,:destroy,:index]
end
