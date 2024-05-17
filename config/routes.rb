Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources :cars do
    member do
      get 'new_mileage', to: 'cars#new_mileage'
      post 'create_mileage', to: 'cars#create_mileage'
    end
  end
end
