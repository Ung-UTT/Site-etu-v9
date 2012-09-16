source 'http://rubygems.org'

gem 'rails'
gem 'sqlite3'
gem 'redis'

gem 'rubycas-client-rails', github: 'rubycas/rubycas-client-rails', ref: '7770e761'
gem 'devise'
gem 'cancan'
gem 'rolify'
gem 'omniconf'

gem 'dynamic_form' # Rend les formulaires plus lisibles
gem 'paperclip'   # Gestion de fichier
gem 'kaminari'    # Pagination
gem 'paper_trail' # Historique
gem 'rdiscount'   # Parsage (Markdown)
gem 'awesome_nested_set' # "Arbres" (Associations, Rôles, ...)
gem 'stringex'
gem 'validates_email_format_of'

group :development do
  gem 'guard-rspec'
  gem 'spork'
  gem 'guard-spork'
  gem 'rb-inotify'
  gem 'libnotify'
  gem 'rails-footnotes'
  gem 'foreman'
  gem 'rspec-rails'
  gem 'brakeman'
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
  gem 'simplecov', github: 'colszowka/simplecov'
  gem 'rails_best_practices'
  gem 'brakeman'
end

# Nécessaires pour l'import de données
group :import do
  gem 'mysql2'
  gem 'net-ldap' # Manipulation d'annuaires LDAP
  gem 'htmlentities'
end

group :production do
  gem 'mysql2'
  gem 'redis-rails'
end

