Rails.application.routes.draw do

  root 'application#index'

  get '/ping', to: 'application#ping'

  get '/about', to: 'application#about'

  get '/sign-in', to: 'sessions#sign_in', as: 'sign_in'
  get '/sign-out', to: 'sessions#sign_out', as: 'sign_out'

  get '/auth', to: 'modders#auth', as: 'auth'
  get '/onboarding', to: 'modders#onboarding', as: 'onboarding'
  get '/profile', to: 'modders#profile', as: 'profile'

end
