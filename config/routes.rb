Rails.application.routes.draw do
  resources :campaigns
  resources :spaces
  devise_for :users

  get "/", to: "pages#home", as: "root"
  
  get "/space_selector/campaigns/:id", to: "space_selector#index", as: "space_selector"
  post "/space_selector/campaigns/:id", to: "space_selector#link"
  delete "/space_selector/campaigns/:id", to: "space_selector#unlink"

  get "/payments/:id", to: "payments#show", as: "payment"
  get "/payments/:id/success", to: "payments#success", as: "payment_success"
  get "/payments/:id/cancel", to: "payments#cancel", as: "payment_cancel"
  post "/payments/webhook", to: "payments#webhook"
end
