Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  get 'settings/show'
root 'home#index'

  get 'home/index'
  get 'how_tos/show'
  mount ActiveStorage::Engine => "/rails/active_storage"
  resources :items

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
 #root 'items#index'
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get '/settings', to: 'settings#show', as: :settings
  
  get '/how_to', to: 'how_tos#show', as: :how_to

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  # Defines the root path route ("/")
  #root "posts#index"
end
