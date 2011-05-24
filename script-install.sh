#!/bin/bash

ruby="ruby ruby1.8-dev ruby-pkg-tools rdoc ri irb libopenssl-ruby"
sqlite3="sqlite3 libsqlite3-ruby libsqlite3-dev"
rubygems="rubygems1.8"
tools="ssh git wget"
libs="libxslt-dev libxml2-dev"
all="$ruby $sqlite3 $rubygems $tools $libs"

echo -n "Ce script est fait pour Ubuntu, si vous êtes sur une autre "
echo "distribution, regardez le code source et modifiez-le."
echo
echo "Les paquets qui vont être installés sont : "
echo $all
echo "Et les gems : rails et celles listées dans le Gemfile"
echo
echo "Normalement vous devez avoir une copie du code source du site étu"
echo "Sinon faîtes : git clone VOTRENOM@172.16.1.102/srv/git/etu/ror"
echo
read -p "Appuyez sur une touche pour continuer…"

sudo apt-get -qq update
sudo apt-get -qq install -y $all
echo "export PATH=/var/lib/gems/1.8/bin:$PATH" >> ~/.bashrc

echo "Installation de rails (ça peut être un peu long)"
sudo gem install rails

# Installe les gems dont le site étu a besoin
bundle install

rake db:migrate

cat README