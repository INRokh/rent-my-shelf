Rails.application.routes.draw do
  resources :campaigns
  resources :spaces
  devise_for :users
  get "/", to: "pages#home", as: "root"
  get "/space_selector/campaigns/:id", to: "space_selector#index", as: "space_selector"
  post "/space_selector/campaigns/:id", to: "space_selector#link"
  delete "/space_selector/campaigns/:id", to: "space_selector#unlink"
end
