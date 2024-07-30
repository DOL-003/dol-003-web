Rails.application.routes.draw do

  namespace :admin do
    resources :modders
    resources :modder_photos
    resources :modder_services
    resources :users
    resources :user_invitations

    root to: 'modders#index'
  end

  devise_for :users, controllers: {
    confirmations: 'authentication/confirmations',
    passwords: 'authentication/passwords',
    registrations: 'authentication/registrations',
    sessions: 'authentication/sessions'
  }

  root 'application#index'

  get 'ping', to: 'application#ping'

  get 'about', to: 'application#about'
  get 'vetting', to: 'application#vetting'
  get 'terms', to: 'application#terms'
  get 'rules', to: 'application#rules'
  get 'privacy', to: 'application#privacy_policy'

  get 'profile', to: 'profiles#show', as: :user_root
  resource :profile, only: %i[edit update create]
  post 'profile/photo', to: 'profiles#upload_photo'
  post 'profile/photo-order', to: 'profiles#reorder_photos'
  post 'profile/remove-photo/:uuid', to: 'profiles#remove_photo'

  # Admin stuff
  resources :profiles, only: %i[new update create]
  get 'profiles/:id/edit', to: 'profiles#edit', as: 'admin_edit_profile'
  patch 'profiles/:id', to: 'profiles#update', as: 'admin_update_profile'
  put 'profiles/:id', to: 'profiles#update'

  resources :modders, only: %i[index show] do
    member do
      get 'report', to: 'modders#new_report'
      post 'report', to: 'modders#create_report'
    end
  end
  resources :invitations, only: %i[new create]

  get 'compendium(/*path)', to: 'compendium#show', as: :compendium

  constraints subdomain: 'compendium' do
    get '/', to: redirect('/compendium')
    get '*path', to: redirect { |path_params| "/compendium/#{path_params[:path]}" }
  end

end
