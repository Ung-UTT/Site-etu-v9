source 'http://rubygems.org'

gem 'rake'
gem 'rails'

gem 'rubycas-client', '2.2.1' # Version spécifique requise
gem 'rubycas-client-rails' # CAS

gem 'bcrypt-ruby', :require => 'bcrypt' # Chiffrement des mots de passe
gem 'dynamic_form' # Rend les formulaires plus lisibles
gem 'cancan'      # Permissions
gem 'paperclip'   # Gestion de fichier
gem 'kaminari'    # Pagination
gem 'paper_trail' # Historique
gem 'rdiscount'   # Parsage (Markdown)
gem 'awesome_nested_set' # "Arbres" (Associations, Rôles, ...)

group :development do
  gem 'sqlite3'
end

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'     # Compression des assets
  gem 'therubyracer' # Interprétation JS
end

group :test do
  gem 'rspec-rails'      # Classes des tests
  gem 'shoulda-matchers' # Fonctions des tests
  gem 'autotest-rails'   # Lancer automatiquement les tests
  gem 'factory_girl_rails' # Fixtures suck
  gem 'capybara'
  gem 'simplecov'
  gem 'rails_best_practices'
end

# Nécessaires pour l'import de données
group :import do
  gem 'net-ldap' # Manipulation d'annuaires LDAP
end

group :production do
  gem 'mysql2'
end

