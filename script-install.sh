# Quelques paquets pratiques
sudo apt-get update
sudo apt-get install -y ssh ruby ruby1.8-dev ruby-pkg-tools rdoc ri irb sqlite3 libopenssl-ruby libsqlite3-ruby sqlitebrowser
sudo apt-get install -y git-core wget

# Rubygemss
sudo apt-get install -y rubygems
echo "export PATH=/var/lib/gems/1.8/bin:$PATH" >> ~/.bashrc

cd ..
rm -r rubygems-1.7.2

sudo ln -s /usr/bin/gem1.8 /usr/bin/gem

sudo gem update --system

# Rails et les gems du site étu
sudo gem install rails
bundle install

echo "Pour créer la base de donnée avec les bonnes tables toussa… :"
echo "  rake db:migrate"
echo
echo "Pour générer plein de contenu (mais détruit tout ce qu'il y a dans la base) :"
echo "  rake db:fixtures:load"
echo
echo "Pour ajouter les utilisateurs de base avec les bons rôles"
echo "  rake db:seed"