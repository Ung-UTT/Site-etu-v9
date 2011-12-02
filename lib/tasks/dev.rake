# encoding: UTF-8 leave this magic comment for rake
namespace :dev do
  desc 'Supprime les bases de données et refais les migrations, les fixtures et les seed'
  task :reset do
    sh %{rm -f db/*.sqlite3 db/schema.rb}
    sh %{rake db:create db:migrate RAILS_ENV=production}
    sh %{rake db:create db:migrate}
    sh %{rake db:create db:migrate RAILS_ENV=test}
  end
end
