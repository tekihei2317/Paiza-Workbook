Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: 'problems#index'

  # Problems
  post 'problems/filter', to: 'problems#filter'
  resources :problems

  # Users
  # resources :users
  get 'users/progress'
  get 'users/recommend'
  get 'users/profile'
end
