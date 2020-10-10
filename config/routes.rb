Rails.application.routes.draw do
  devise_for :users, controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations',
                       passwords: 'users/passwords',
                       omniauth_callbacks: 'users/omniauth_callbacks',
                     }
  root to: 'problems#index'

  # Problems
  post 'problems/filter', to: 'problems#filter'
  resources :problems

  # Users
  # resources :users
  get 'users/progress'
  get 'users/recommend'
  get 'users/profile'
  post 'users/update/problems', to: 'users#update_solved_problems'
end
