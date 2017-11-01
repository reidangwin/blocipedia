Rails.application.routes.draw do
  resources :wikis

  resources :charges, only: [:new, :create]

  root 'welcome#index'

  get 'welcome/about'

  post '/downgrade-account' => 'charges#downgrade', as: :downgrade_account

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
