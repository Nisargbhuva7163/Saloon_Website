Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  devise_scope :user do
    post "users/send_otp", to: "users/sessions#send_otp", as: :users_send_otp
    post "users/verify_otp", to: "users/sessions#verify_otp", as: :users_verify_otp
    post "/users/resend_otp", to: "users/sessions#resend_otp", as: :users_resend_otp

  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  root to: "services#new"
  # Defines the root path route ("/")
  resources :services
  resources :combos
  resources :customers

  resources :customer_combos, only: [ :index, :create ] do
    collection do
      post :select_customer             # Step 1: Select a customer with radio button
      get :assign_combo                 # Step 2: Assign combo to selected customer
    end
  end

  # Routes for Redeems (Selection, Checking, and Redemption)
  resources :redeems, only: [ :index ] do
    collection do
      post :select_customer             # Step 1: Select a customer for redeeming
      get  :check_combos                # Step 2: Display customer's available combos
      post :redeem_combo                # Step 3: Redeem a selected combo
    end
  end
end
