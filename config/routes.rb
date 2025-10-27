Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: "users/registrations",
    passwords: "users/passwords"
  }

root 'home#index'

  get 'home/index'
  mount ActiveStorage::Engine => "/rails/active_storage"
  resources :items

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
 #root 'items#index'
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resource :settings, only: [:show, :update]
  
  get '/how_to', to: 'how_tos#show', as: :how_to
  get '/welcome', to: 'how_tos#welcome', as: :welcome

  get '/share_closet', to: 'closets#share', as: :share_closet

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  # Defines the root path route ("/")
  #root "posts#index"
end
