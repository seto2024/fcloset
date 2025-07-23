Rails.application.routes.draw do
  get 'how_tos/show'
  mount ActiveStorage::Engine => "/rails/active_storage"
  resources :items

get   '/password_reset/new',               to: 'password_resets#new',    as: :new_password_reset
post  '/password_reset',                   to: 'password_resets#create', as: :password_resets
get   '/password_reset/:token/edit',       to: 'password_resets#edit',   as: :edit_password_reset
patch '/password_reset/:token',            to: 'password_resets#update', as: :password_reset
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
 root 'items#index'
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get  '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  get '/how_to', to: 'how_tos#show', as: :how_to
  resources :password_resets, only: [:new, :create, :edit, :update], param: :token

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  # Defines the root path route ("/")
  #root "posts#index"
end
