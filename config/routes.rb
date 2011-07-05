SiteEtu::Application.routes.draw do
  match 'quotes/random' => 'quotes#random'

  # TODO: Réorganiser joliment les join/disjoin
  match 'events/:id/join' => 'events#join', :as => 'join_event'
  match 'events/:id/disjoin' => 'events#disjoin', :as => 'disjoin_event'
  match 'associations/:id/join' => 'associations#join', :as => 'join_association'
  match 'associations/:id/disjoin' => 'associations#disjoin', :as => 'disjoin_association'
  match 'projects/:id/join' => 'projects#join', :as => 'join_project'
  match 'projects/:id/disjoin' => 'projects#disjoin', :as => 'disjoin_project'
  match 'roles/:id/join' => 'roles#join', :as => 'join_role'
  match 'roles/:id/disjoin/:user_id' => 'roles#disjoin', :as => 'disjoin_role'
  match 'groups/:id/join' => 'groups#join', :as => 'join_group'
  match 'groups/:id/disjoin/:user_id' => 'groups#disjoin', :as => 'disjoin_group'

  match 'login' => 'user_sessions#new'
  match 'logout' => 'user_sessions#destroy'

  match 'auth/:provider' => 'authorizations#create', :as => 'auth'
  match 'auth/:provider/callback' => 'authorizations#create'
  match 'auth/failure' => 'authorizations#failure'

  match 'news/daymail' => 'News#daymail'
  match 'users/password_reset' => 'Users#password_reset', :as => 'password_reset'

  resources :tags, :only => [:index, :show]

  resources :authorizations, :groups, :reminders, :roles, :timesheets, :users
  resources :user_sessions, :only => :create
  resources :annals, :associations, :classifieds, :carpools, :courses, :events, :projects, :quotes, :news do
    resources :comments
    resources :documents
  end

  match '/:action' => 'home'
  root :to => 'home#index'
end
