Rails.application.routes.draw do
  resources :wikis

  resources :charges, only: [:new, :create]

  root 'welcome#index'

  get 'welcome/about'

  post '/downgrade-account', to:'charges#downgrade', as: :downgrade_account

  devise_for :users

  resources :wikis do
    resources :collaborators, only: [:new, :create, :destroy]
  end
end
