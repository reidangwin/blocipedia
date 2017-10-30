Rails.application.routes.draw do
  resources :wikis

  root 'welcome#index'

  get 'welcome/about'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
