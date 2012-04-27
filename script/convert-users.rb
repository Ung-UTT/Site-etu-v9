#!/usr/bin/env ruby1.8
# encoding: utf-8
# Script à part car doit être éxécuté avec ruby 1.8.7 ! (bug de net-ldap)
# Rake requiert l'environnement Rails donc ruby 1.9.2 donc on ne peut pas
# utiliser rake
# Et s'il est placé dans lib/tasks : rake l'éxécutera lors de son chargement

require 'rubygems'
require 'net-ldap'

# Dans le répertoire temporaire de Rails
DB_FILE = File.dirname(__FILE__) + '/../tmp/users.marshal'

         # Éléves
attrs = ['uid', 'mail', 'givenname', 'sn', 'displayname', 'employeetype',
         'niveau', 'filiere', 'supannetuid', 'jpegphoto', 'uv',
         # Profs
         'roomnumber', 'telephonenumber', 'businesscategory']

puts "Get informations about students :"
if File.exists?(DB_FILE)
  puts "#{DB_FILE.to_s.split('/').last} already exists, you can now insert users"
  exit
end

begin
  utt = Net::LDAP.new(:host => 'ldap.utt.fr', :port => 389, :base => "dn:dc=utt,dc=fr")
rescue
  puts "Can't connect to LDAP server"
  exit
end

puts "Search students (slow)..."

# Recherche de tout les étudiants
students = utt.search(:base => 'ou=people,dc=utt,dc=fr')

# Tranformation du tableau d'objets LDAP en un tableau de hashs
students.map! do |st|
  tmp_hash = Hash.new # Chaque étudiant est stocké
  attrs.each do |attr|
    val = st[attr]
    # Les attributs seuls sont dans un tableau
    val = attr == 'uv' ? val.map(&:to_s).to_a : val.to_s
    val = nil if val == 'NC'
    tmp_hash.merge!({attr => val})
  end
  tmp_hash
end

# Ne garder que les personnes (pas les ordis, les comptes d'administrations, ... etc)
students = students.reject {|st| st['supannetuid'].empty? }

File.open(DB_FILE, 'w+') {|f| f.write(Marshal.dump(students))}
