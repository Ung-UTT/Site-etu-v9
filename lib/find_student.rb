# encoding: utf-8

# Est appellée par lib/tasks/import/convert-schedules.rake
require File.expand_path("../../config/environment", __FILE__)
require 'readline'

# Évite les requêtes SQL
PROFILES = Profile.all
USERS = User.all

def find_user(id)
  USERS.detect {|u| u.id == id}.login
end

# Trouver l'étudiant par rapport à son ID (pas forcement correct (9999)),
# son prénom/nom coupé, sa branche et éventuelement peut recourir à une
# manipulation humaine... mais ne devrait pas
# Retourne le login de l'étudiant
def find_student(id, names, level)
  names = names.split(' ') || [] # FOUQUET JU, COLSON VAL, ...
  names.push('') while names.size < 2
  reg_names = names.map{|n| /^#{Regexp.escape(n)}/i }

  if id < 99000 # IDs existants vraiment
    # Recherche par ID étudiant
    profile = PROFILES.detect {|p| p.utt_id == id }
    if !profile.nil? and !profile.user_id.nil?
      return find_user(profile.user_id)
    end
  end

  # Recherche par élimination : branche, nom, prénom
  profiles = PROFILES.select {|p| p.level == level}

  # Recherche par nom, avec restauration si rien de trouvé
  if !profiles.nil? and profiles.size > 1
    new = profiles.select {|p| p.lastname =~ reg_names[0] }
    profiles = new if new.size > 1
  end

  # Recherche par prénom, avec restauration si rien de trouvé
  if !profiles.nil? and profiles.size > 1
    new = profiles.select {|p| p.firstname =~ reg_names[1] }
    profiles = new if new.size > 1
  end

  if profile.nil? or profile.empty?
    # FIXME: Avec les bons emplois du temps, on cherchera à tout
    #        tout prix à trouver quelqu'un, là pour les tests on
    #        ignore les étudiants non trouvés
    return '' # TODO: Proposer un choix plus large
  elsif profiles.size == 1
    puts "On a trouve quelqu'un"
    return find_user(profiles.first.user_id)
  else
    puts 'Choose between students found :'
    puts "Indices : #{id} #{level} #{names.join(' ')}"
    profiles.each {|profile| puts "#{profile.user.login} : #{profile.level}" }
    login = Readline.readline('> ')
    return login
  end
end
