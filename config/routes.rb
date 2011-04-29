SiteEtu::Application.routes.draw do
  match 'quotes/random' => 'quotes#random'

  resources :quotes
  resources :news
  resources :users
  resources :user_sessions, :only => :create

  match 'login' => 'user_sessions#new'
  match 'logout' => 'user_sessions#destroy'

  root :to => 'home#index'
end
