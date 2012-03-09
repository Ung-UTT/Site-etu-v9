SiteEtu::Application.routes.draw do
  # Routes spéciales
  match 'quotes/random' => 'quotes#random' # Random quote
  match 'cas/new' => 'cas#new', :as => 'cas_new' # Connexion CAS
  match 'login' => 'user_sessions#new' # Connexion classique
  match 'logout' => 'user_sessions#destroy' # Déconnexion
  match 'news/daymail' => 'News#daymail' # Envoyer le Daymail
  match 'users/password_reset' => 'Users#password_reset', :as => 'password_reset' # Oubli de mot de passe
  match 'about' => 'home#about' # Page "À propos"

  # Les join/disjoin (à mettre dans des ressources et écrire les controlleurs)
  match 'events/:id/join' => 'events#join', :as => 'join_event'
  match 'events/:id/disjoin' => 'events#disjoin', :as => 'disjoin_event'

  match 'assos/:id/join' => 'assos#join', :as => 'join_asso'
  match 'assos/:id/disjoin' => 'assos#disjoin', :as => 'disjoin_asso'

  match 'projects/:id/join' => 'projects#join', :as => 'join_project'
  match 'projects/:id/disjoin' => 'projects#disjoin', :as => 'disjoin_project'

  match 'roles/:id/join' => 'roles#join', :as => 'join_role'
  match 'roles/:id/disjoin/:user_id' => 'roles#disjoin', :as => 'disjoin_role'

  match 'groups/:id/join' => 'groups#join', :as => 'join_group'
  match 'groups/:id/disjoin/:user_id' => 'groups#disjoin', :as => 'disjoin_group'

  # Ressources
  resources :albums, :answers, :authorizations, :groups, :polls, :reminders,
            :roles, :timesheets, :users, :user_sessions, :votes
  resources :annals, :assos, :classifieds, :carpools, :courses, :events, :projects, :quotes, :news do
    resources :comments
    resources :documents
  end

  root :to => 'home#index'

  match '*path' => 'application#render_not_found'
end
