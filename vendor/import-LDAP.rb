#!/usr/bin/env ruby

require File.expand_path("../../config/environment", __FILE__)
require 'rubygems'
require 'net-ldap'
require 'open-uri'

DB_FILE = Rails.root.join('vendor', 'data', 'ldap.marshal')

         # Éléves
attrs = ['uid', 'mail', 'givenname', 'sn', 'displayname', 'employeetype',
         'niveau', 'filiere', 'supannetuid', 'jpegphoto', 'uv',
         # Profs
         'roomnumber', 'telephonenumber', 'businesscategory']

puts "Récupuration des infos sur les étudiants"
if File.exists?(DB_FILE)
  puts "Utilisation de #{BD_FILE.to_s} (à supprimer si vous voulez les dernière infos du LDAP)"
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
    tmp_hash = Hash.new # Chaque étudiant est stocké
    attrs.each do |attr|
      val = st[attr]
      val = val.to_s unless attr == 'uv' # Les attributs seuls sont dans un tableau
      val = nil if val == 'NC'
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

  # Créer ou mettre à jour
  u = User.find_by_login(st['uid']) || User.simple_create(st['uid'])

  # E-Mail
  u.email = st['mail']

  # On va écrire les détails dans le profil (le crée s'il ne l'est pas déjà)
  u.build_profile.save unless u.profile

  # Photo de profil
  begin
    picture = Image.from_url(st['jpegphoto'])
  rescue => e
    puts e.inspect
    puts "Pas de photo de profil car pas d'accès Internet"
    picture = nil
  end
  picture.inspect
  u.profile.image = Image.new(:asset => picture) if picture

  u.profile.utt_id = st['uid']
  u.profile.firstname = st['givenname']
  u.profile.lastname = st['sn']
  u.profile.level = st['niveau']
  u.profile.specialization = st['filiere']
  u.profile.role = st['employeetype']
  u.profile.phone = st['telephonenumber']
  u.profile.room = st['roomnumber']

  # Les UVs sont ajoutées via les emploi du temps
  # (Un utilisateur suit un cours si il participe à au moins une horaire)

  # Ajouter le rôle d'étudiant si il l'est ;-)
  u.become_a_student if st['employeetype'] == 'student'

  # On sauvegarde le tout
  unless u.save
    puts u.errors.inspect
  end
end

