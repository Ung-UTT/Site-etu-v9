SiteEtu::Application.routes.draw do
  devise_for :users

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
    resources :documents, only: [:index, :create, :destroy]
  end
  resources :assos, :events, :projects, only: [ ] do
    # 'only: [ ]' because we don't want duplicated default routes (#index, #show, etc.)
    member do
      post :join
      post :disjoin
    end
  end

  root to: 'home#index'

  # Routes spéciales
  match 'about' => 'home#about', via: :get
  match 'rules' => 'home#rules', via: :get
  match 'deploy' => 'application#deploy', via: :get
  match 'preview' => 'application#preview' # Prévisualisation Markdown
  match '*path' => 'application#render_not_found'
end
