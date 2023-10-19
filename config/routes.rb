Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      get "/merchants/find", to: "merchants/search#show"
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: "merchants/items"
      end

      get "/items/find_all", to: "items/search#index"
      resources :items, only: [:index, :show, :create, :destroy, :update] do
        get "/merchant", to: "items/merchants#show"
      end
    end
  end
end
