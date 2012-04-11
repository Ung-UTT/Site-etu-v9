source 'http://rubygems.org'

gem 'rake'
gem 'rails', '~> 3.2.0'
gem 'sqlite3'

# Pour importer des données

# Gems desormais obligatoires
gem 'uglifier'     # Compréssion des assets
gem 'therubyracer' # Interprétation JS
gem 'sass'         # CSS simplifié
gem 'dynamic_form' # Rend les formulaires plus lisibles

# Chiffrement des mots de passe
gem 'bcrypt-ruby', :require => 'bcrypt'

gem 'rubycas-client', '2.2.1' # Version spécifique requise
gem 'rubycas-client-rails' # CAS

gem 'cancan'      # Permissions
gem 'paperclip'   # Gestion de fichier
gem 'kaminari'    # Pagination
gem 'paper_trail' # Historique
gem 'rdiscount'   # Parsage (Markdown)
gem 'awesome_nested_set' # "Arbres" (Associations, Rôles, ...)

group :test do
  gem 'rspec-rails'      # Classes des tests
  gem 'shoulda-matchers' # Fonctions des tests
  gem 'autotest-rails'   # Lancer automatiquement les tests
  gem 'simplecov', :require => false
end

# Necessaires pour l'import de données
group :import do
  gem 'mysql2' # Intéragir avec les bases MySQL
  gem 'net-ldap' # Manipulation d'annuaires LDAP
end
