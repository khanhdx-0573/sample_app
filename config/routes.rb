Rails.application.routes.draw do
    get "static_pages/home"
    get "static_pages/help"

    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    resources :users

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout",to: "sessions#destroy"

    resources :account_activations, only: :edit
    resources :password_resets, only: %i(new create edit update)

    root "static_pages#home"
end
