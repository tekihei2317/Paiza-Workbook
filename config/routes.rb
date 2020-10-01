Rails.application.routes.draw do
  devise_for :users
  root to: 'problems#index'

  # Problems
  post 'problems/filter', to: 'problems#filter'
  # problems/filterでリロードしたとき用
  get 'problems/filter', to: 'problems#index'
  resources :problems

  # Users
  resources :users
end
