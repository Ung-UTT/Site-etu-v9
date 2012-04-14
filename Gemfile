source 'http://rubygems.org'

gem 'rake'
gem 'rails'
gem 'sqlite3'

gem 'uglifier'     # Compression des assets
gem 'therubyracer' # Interprétation JS
gem 'sass'         # CSS simplifié
gem 'dynamic_form' # Rend les formulaires plus lisibles

gem 'bcrypt-ruby', :require => 'bcrypt' # Chiffrement des mots de passe

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
  gem 'factory_girl_rails' # Fixtures suck
  gem 'simplecov', :require => false
end

# Nécessaires pour l'import de données
group :import do
  gem 'mysql2', :require => false # Intéragir avec les bases MySQL
  gem 'net-ldap', :require => false # Manipulation d'annuaires LDAP
end
