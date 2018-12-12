Rails.application.routes.draw do
  root 'users#index'
  namespace :users do
    get 'omniauth_callbacks/vkontakte'
  end
  devise_for :users, 
    controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
