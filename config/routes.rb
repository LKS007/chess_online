Rails.application.routes.draw do
  get 'game/start_game', as: :start_game 
  get 'game/end_game'
  post 'game/make_step'
  get '/' => 'welcome#index'
  get 'profile' => 'users#profile_info'
  root 'users#profile_info'
  namespace :users do
    get 'omniauth_callbacks/vkontakte'
  end
  devise_for :users, 
    controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  resources :users
end
