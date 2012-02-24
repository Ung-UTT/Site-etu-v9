# encoding: UTF-8

namespace :dev do
  desc 'Supprime les bases de données et refais les migrations, les fixtures et les seed'
  task :reset do
    sh %{rm -f db/*.sqlite3 db/schema.rb}
    sh %{rake db:migrate db:fixtures:load db:seed}
    sh %{rake db:migrate db:seed RAILS_ENV=production}
    sh %{rake db:migrate db:seed RAILS_ENV=test}
  end
end
