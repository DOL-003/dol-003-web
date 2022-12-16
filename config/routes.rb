Rails.application.routes.draw do
  devise_for :users

  root 'application#index'

  get '/ping', to: 'application#ping'

  get '/about', to: 'application#about'

  get '/profile', to: 'profiles#show', as: :user_root
  resource :profile, only: [:edit, :update, :create]

  resources :modders, only: [:index, :show]

end
