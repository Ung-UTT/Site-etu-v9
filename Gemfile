source 'http://rubygems.org'

gem 'rake'
gem 'rails', '~> 3.2.0'
gem 'sqlite3'

# Gems desormais obligatoires
gem 'uglifier'     # Compression assets
gem 'therubyracer' # Interpretation JS
gem 'sass'         # CSS simplifié
gem 'dynamic_form' # Rend les formulaires plus lisibles

# Chiffrement des mot de passe
gem 'bcrypt-ruby', :require => 'bcrypt'

gem 'rubycas-client', '2.2.1' # Version spécifique requise
gem 'rubycas-client-rails' # CAS

gem 'cancan'      # Permissions
gem 'paperclip'   # Gestion de fichier
gem 'kaminari'    # Pagination
gem 'paper_trail' # Historique
gem 'rdiscount'   # Parsage (Markdown)
gem 'awesome_nested_set' # "Arbres" (Associations, Rôles, ...)
gem 'net-ldap'    # Manipulation d'annuaires LDAP

group :test do
  gem 'rspec-rails'      # Classes des tests
  gem 'shoulda-matchers' # Fonctions des tests
  gem 'autotest-rails'   # Lancer automatiquement les tests
  gem 'factory_girl_rails' # Fixtures suck
  gem 'simplecov', :require => false
end
