#!/usr/bin/env ruby

require File.expand_path("../../config/environment", __FILE__)
require 'rubygems'
require 'net-ldap'

DB_FILE = Rails.root.join('vendor', 'ldap.marshal')

         # Éléves
attrs = ['uid', 'mail', 'givenname', 'sn', 'displayname', 'employeetype',
         'niveau', 'filiere', 'supannetuid', 'jpegphoto', 'uv',
         # Profs
         'roomnumber', 'telephonenumber', 'businesscategory']

puts "Récupuration des infos sur les étudiants"
if File.exists?(DB_FILE)
  students = Marshal.load(File.read(DB_FILE))
else
  begin
    utt = Net::LDAP.new(:host => 'ldap.utt.fr', :port => 389, :base => "dn:dc=utt,dc=fr")
  rescue
    puts "Impossible de se connecter au LDAP de l'UTT"
    exit
  end

  puts "Chargement depuis le LDAP de l'UTT (long)"
  # Recherche de tout les étudiants
  students = utt.search(:base => 'ou=people,dc=utt,dc=fr')

  # Tranformation du tableau d'objets LDAP en un tableau de hashs
  students.map! do |st|
    tmp_hash = Hash.new # Chaque étudiant est stok
    attrs.each do |attr|
      val = st[attr]
      val = val.to_s unless attr == 'uv' # Les attributs seuls sont dans un tableau
      tmp_hash.merge!({attr => val})
    end
    tmp_hash
  end

  # Ne garder que les personnes (pas les ordis, les comptes d'administrations, ... etc)
  students.select {|st| !st['supannetuid'].empty?}

  File.open(DB_FILE, 'w+') {|f| f.write(Marshal.dump(students))}
end

puts "Insertion des étudiants dans la base de données"
students.each do |st|
  puts "#{st['supannetuid']} : #{st['displayname']}"
  u = User.find_by_login(st['uid']) || User.simple_create(st['uid'])
  u.email = st['mail']
  u.save
end

