Rails.application.routes.draw do
  devise_for :users
  root to: 'problems#index'

  # Problems
  resources :problems
  post 'problems/filter', to: 'problems#filter'

  # Users
  resources :users
end
