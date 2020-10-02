Rails.application.routes.draw do
  devise_for :users
  root to: 'problems#index'

  # Problems
  post 'problems/filter', to: 'problems#filter'
  resources :problems

  # Users
  resources :users
end
