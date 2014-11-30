YygServer::Application.routes.draw do

  root to: 'home#index'

  resources :products, only: [:index]
  resources :sub_products, only: [:index]

  # ------------------ ADMIN ------------------ #
  namespace :admin do
    root to: 'dashboard#index'
  end

  # ------------------- API ------------------- #
  namespace :api do
    namespace :v1 do
      #Licences
      resources :licences, only: [:index]

      #Sub Licences
      resources :sub_licences, only: [:index]

      #Products
      resources :products, only: [:index, :show]

      #Sub Products
      resources :sub_products, only: [:index, :show]
    end #V1
  end #Api

end
