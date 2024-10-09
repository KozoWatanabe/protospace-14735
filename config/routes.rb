Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:edit, :update, :show]
  resources :prototypes do
  resources :comments, only: :create
  end
  root to: "prototypes#index"
end
