Rails.application.routes.draw do
  root 'devs#index'
  resources :devs, only: [:index, :create]
end
