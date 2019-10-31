Rails.application.routes.draw do
  resources :campaigns
  resources :spaces
  devise_for :users
  get "/", to: "pages#home", as: "root"
end
