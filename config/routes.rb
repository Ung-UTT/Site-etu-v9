SiteEtu::Application.routes.draw do
  devise_for :users

  # Routes spéciales
  match 'about' => 'home#about' # Page "À propos"
  match 'rules' => 'home#rules' # Page "Règles"
  match 'preview' => 'application#preview' # Prévisualisation Markdown

  # Ressources
  resource :cas, :only => [:new, :destroy]

  resources :answers, :only => [:create, :destroy]
  resources :users, :only => [:index, :edit, :show, :update]
  resources :authorizations, :polls, :timesheets, :votes, :quotes
  resources :courses do
    resources :comments
  end
  resources :annals, :assos, :classifieds, :carpools, :events, :projects,
            :news, :wikis do
    resources :comments
    resources :documents
  end
  resources :assos, :events, :projects, :roles do
    member do
      post :join
      post :disjoin
    end
  end

  root :to => 'home#index'

  match '*path' => 'application#render_not_found'
end
