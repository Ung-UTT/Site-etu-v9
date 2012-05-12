source 'http://rubygems.org'

gem 'rake'
gem 'rails'
gem 'sqlite3'

gem 'rubycas-client-rails', :git => 'https://github.com/rubycas/rubycas-client-rails.git', :ref => '7770e761'
gem 'devise'
gem 'cancan'
gem 'rolify'

gem 'dynamic_form' # Rend les formulaires plus lisibles
gem 'paperclip'   # Gestion de fichier
gem 'kaminari'    # Pagination
gem 'paper_trail' # Historique
gem 'rdiscount'   # Parsage (Markdown)
gem 'awesome_nested_set' # "Arbres" (Associations, Rôles, ...)
gem 'stringex'

group :development do
  gem 'guard-rspec'
  gem 'spork'
  gem 'guard-spork'
  gem 'rb-inotify'
  gem 'libnotify'
end

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'haml-rails'
  gem 'uglifier'     # Compression des assets
  gem 'therubyracer' # Interprétation JS
end

group :test do
  gem 'rspec-rails'      # Classes des tests
  gem 'shoulda-matchers' # Fonctions des tests
  gem 'factory_girl_rails' # Fixtures suck
  gem 'capybara'
  gem 'simplecov'
  gem 'rails_best_practices'
end

# Nécessaires pour l'import de données
group :import do
  gem 'mysql2'
  gem 'net-ldap' # Manipulation d'annuaires LDAP
  gem 'htmlentities'
end

group :production do
  gem 'mysql2'
end

