namespace :dev do
  desc 'Supprime les bases de données et refais les migrations'
  task :reset do
    sh %{rm db/*.sqlite3}
    sh %{rake db:create}
    sh %{rake db:migrate}
  end

  desc 'Liste de tout le fichiers éditables'
  task :list do
    sh %{find . -type f | egrep -v "(git|images|tmp|cache|plugins)"}
  end
end