Rails.application.routes.draw do
  devise_for :users

  root 'application#index'

  get '/ping', to: 'application#ping'

  get '/about', to: 'application#about'

  get '/auth', to: 'modders#auth', as: 'auth'
  get '/onboarding', to: 'modders#onboarding', as: 'onboarding'
  get '/profile', to: 'modders#profile', as: 'profile'

end
