Rails.application.routes.draw do

  root 'application#index'

  get '/ping', to: 'application#ping'

  get '/about', to: 'application#about'

  get '/auth', to: 'sessions#login'

end
