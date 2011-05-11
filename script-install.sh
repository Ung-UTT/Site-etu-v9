# Quelques paquets pratiques
sudo apt-get update
sudo apt-get install -y ssh ruby ruby1.8-dev ruby-pkg-tools rdoc ri irb sqlite3 libopenssl-ruby libsqlite3-ruby sqlitebrowser
sudo apt-get install -y git-core wget

# RubyGems
wget http://production.cf.rubygems.org/rubygems/rubygems-1.7.2.tgz
tar -xf rubygems-1.7.2.tgz
cd rubygems-1.7.2
sudo ruby setup.rb

cd ..
rm -r rubygems-1.7.2

sudo ln -s /usr/bin/gem1.8 /usr/bin/gem

sudo gem update --system

# Rails et les gems du site étu
sudo gem install rails
bundle install