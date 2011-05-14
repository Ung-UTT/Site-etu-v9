ruby="ruby ruby1.8-dev ruby-pkg-tools rdoc ri irb libopenssl-ruby"
sqlite3="sqlite3 libsqlite3-ruby libsqlite3-dev"
rubygems="rubygems1.8"
tools="ssh git wget"
libs="libxslt-dev libxml2-dev"
all="$ruby $sqlite3 $rubygems $tools $libs"

sudo apt-get -qq update
sudo apt-get -qq install -y $all
echo "export PATH=/var/lib/gems/1.8/bin:$PATH" >> ~/.bashrc

echo "Installation de rails (ça peut être un peu long)"
sudo gem install rails

# Installe les gems dont le site étu a besoin
bundle install

rake db:migrate

cat README