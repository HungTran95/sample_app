Rails.application.routes.draw do
  root "static_pages#home"
  get "sessions/new"
  get "static_pages/home"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  resources :users, only: %i(new show create)
end
