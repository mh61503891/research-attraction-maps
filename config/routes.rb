Rails.application.routes.draw do
  root to:'root#index'
  resources :attractions, only:[:index], format:/json/
  resources :researches, only:[:index], format:/json/
end
