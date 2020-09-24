Rails.application.routes.draw do
  devise_for :users
  root to: 'problems#index'

  # Problems
  resources :problems

  # Users
  resources :users
end
