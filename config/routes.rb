Rails.application.routes.draw do

  root 'application#index'

  get '/ping', to: 'application#ping'

  get '/test', to: 'application#test'

end
