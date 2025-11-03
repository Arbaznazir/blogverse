Rails.application.routes.draw do
  root "posts#index" 

  resources :users
  resources :posts 

  resource :session, only: [:new, :create, :destroy]
end
