Rails.application.routes.draw do
  root to: "problems#index"

  # Problems
  resources :problems
end
