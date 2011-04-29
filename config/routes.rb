SiteEtu::Application.routes.draw do
  resources :quotes
  resources :news
  resources :users
  resources :user_sessions, :only => :create

  match 'login' => 'user_sessions#new'
  match 'logout' => 'user_sessions#destroy'

  root :to => 'home#index'
end
