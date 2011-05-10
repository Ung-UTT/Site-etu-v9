SiteEtu::Application.routes.draw do
  match 'quotes/random' => 'quotes#random'
  match 'events/:id/join' => 'events#join', :as => 'join_event'
  match 'events/:id/disjoin' => 'events#disjoin', :as => 'disjoin_event'
  match 'associations/:id/join' => 'associations#join', :as => 'join_association'
  match 'associations/:id/disjoin' => 'associations#disjoin', :as => 'disjoin_association'
  match 'login' => 'user_sessions#new'
  match 'logout' => 'user_sessions#destroy'
  match '/auth/:provider/callback' => 'authorizations#create'
  match '/auth/failure' => 'authorizations#failure'

  resources :authorizations, :users, :reminders, :roles
  resources :user_sessions, :only => :create
  resources :associations, :classifieds, :carpools, :courses, :events, :quotes, :news do
    resources :comments
  end

  match '/:action' => 'home'
  root :to => 'home#index'
end
