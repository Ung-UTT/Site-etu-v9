SiteEtu::Application.routes.draw do
  devise_for :users

  # Routes spéciales
  match 'about' => 'home#about' # Page "À propos"
  match 'rules' => 'home#rules' # Page "Règles"
  match 'preview' => 'application#preview' # Prévisualisation Markdown

  # Ressources
  resource :cas, only: [:new, :destroy]

  resources :users, only: [:index, :edit, :show, :update]
  resources :polls, :timesheets, :quotes
  resources :roles, except: [:new, :create]
  resources :courses do
    resources :comments, only: [:index, :show, :create, :destroy]
  end
  resources :assos, :classifieds, :carpools, :events, :projects,
            :news, :wikis, :annals do
    resources :comments, only: [:index, :show, :create, :destroy]
    resources :documents, only: [:index, :show, :create, :destroy]
  end
  resources :assos, :events, :projects, only: [ ] do
    # 'only: [ ]' because we don't want duplicated default routes (#index, #show, etc.)
    member do
      post :join
      post :disjoin
    end
  end

  root to: 'home#index'

  match '*path' => 'application#render_not_found'
end
