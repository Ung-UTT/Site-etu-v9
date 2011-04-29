SiteEtu::Application.routes.draw do
  match 'quotes/random' => 'quotes#random'
  match 'events/:id/join' => 'events#join', :as => 'join_event'
  match 'events/:id/disjoin' => 'events#disjoin', :as => 'disjoin_event'
  match 'login' => 'user_sessions#new'
  match 'logout' => 'user_sessions#destroy'

  resources :events
  resources :quotes
  resources :news
  resources :users
  resources :user_sessions, :only => :create

  root :to => 'home#index'
end
