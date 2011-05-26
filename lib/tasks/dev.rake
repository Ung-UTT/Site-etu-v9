namespace :dev do
  desc 'Supprime les bases de données et refais les migrations, les fixtures et les seed'
  task :reset do
    sh %{rm db/*.sqlite3}
    sh %{rm db/schema.rb}
    sh %{rake db:create}
    sh %{rake db:migrate}
    sh %{rake db:fixtures:load}
    sh %{rake db:seed}
  end

  desc 'Liste de tout le fichiers éditables'
  task :list do
    sh %{find . -type f | egrep -v "(git|images|tmp|cache|plugins)"}
  end
end