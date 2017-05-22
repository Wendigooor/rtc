Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }

  resources :products
  resources :charges, only: [:new, :create]

  root 'products#index'
end
