#!/usr/bin/env ruby

# Convertit les exports de la base SQL de l'UTT en un fichier .marshal
# qui est un hash de trois tableaux : horaires, salles et utilisateurs

# À partir des fichiers .sql reçus, il faut les importer dans une base
# MySQL

# Le but est à partir des tables hideuses fournies on arrive à un hash
# des propriétés utiles bien présentées

require File.expand_path("../../config/environment", __FILE__)
require 'mysql2'

DB_FILE = Rails.root.join('vendor', 'data', 'schedule.marshal')

# Nom de la table des horaires
TIMESHEETS_TABLE = 'export_UNGA11'

# Attributs à traduire
attrs = {
  'weekname' => 'weekname', # T, A, B
  'semaine' => 'week', # 1, 2 : toutes les semaines, ou 1 semaine sur 2 # FIXME : utile ?
  'id' => 'room', # C101, A002, ...
  'etu_id' => 'students', # ['mariedor', 'thevenin' ...]
  'uv' => 'uv', # MTX2, LE08
  'type' => 'type', # TD, CM, TP
  'jour' => 'day', # lundi, mardi, mercredi, jeudi, vendredi, samedi => 0..6
  'debut' => 'start', # 8:0, 14:0, 8:30 => [8, 0], ...
  'fin' => 'end', # 19:30, 10:60, 8:60 => [19, 30], ...
}

# Trouver l'étudiant par rapport à son ID (pas forcement correct (9999)),
# son prénom/nom coupé, sa branche et éventuelement peut recourir à une
# manipulation humaine... mais ne devrait pas
# Retourne le login de l'étudiant
def find_student_with(ts)
  id = ts['etu_id']
  level = ts['branche']
  names = ts['nom_prenom'].split(' ') # FOUQUET JU, COLSON VAL, ...
  names.push('') while names.size < 2
  names = names.map{|n| /^#{Regexp.escape(n)}/i }

  # Recherche par ID étudiant
  profile = Profile.find_by_utt_id(id)
  unless profile.nil? or profile.empty?
    return profile.user.login if profile
  end

  # Recherche par élimination : branche, nom, prénom
  profiles = Profile.find_by_level(level)
  profiles = profiles.select {|p| p.lastname =~ names[0] }
  profiles = profiles.select {|p| p.firstname =~ names[1] }

  if profiles.size == 1
    return profiles.first.user.login
  elsif profiles.size > 1
    # TODO: Choisir manuellement entre les utilisateurs
    puts 'Plusieurs étudiants trouvés, à vous de choisir :'
    return profiles.first.user.login
  else
    puts 'Aucun utilisateur trouvé...'
    # TODO: Faire choisir via un choix plus large d'utilisateurs
    # (seulement nom, seulement prénom, ...)
    return ''
  end
end

puts 'Get schedules'
if File.exists?(DB_FILE)
  puts "The file #{BD_FILE.to_s} already exists, you can now import " +
       "the schedules"
  exit
else
  begin
    base = Mysql2::Client.new(
      :host => 'localhost',
      :username => 'utt_edt',
      :password => 'utt_edt',
      :database => 'utt_edt'
    )
  rescue
    puts "Can't connect to the MySQL server"
    exit
  end

  # Récupére les salles
  query = base.query('SELECT * FROM rel_seance_salle')
  rooms = []
  query.each(:as => :array) do |room|
    rooms.push([room[0], room[1]])
  end
  # Sépare les index et les noms
  rooms_index = rooms.map{|r| r[0]}
  rooms_names = rooms.map{|r| r[1]}

  # Récupére les horaires
  query = base.query("SELECT * FROM #{TIMESHEETS_TABLE}")
  timesheets = []
  query.each do |ts|
    timesheets.push(ts)
  end

  # Tableau de hash (traduction noms des champs, et parsage des valeurs)
  timesheets = timesheets.map do |ts|
    tmp_hash = Hash.new
    attrs.each do |attr, translation|
      val = ts[attr] # Récupére la valeur

      case translation
        when 'week', 'students'
          val = val.to_i
        when 'students'
          # Trouver l'étudiant par rapport aux indices laissés par l'UTT...
          val = [find_student_with(ts)]
        when 'room'
          # Selectionne la salle qui correspond à l'id de l'horaire et
          # récupère la nom de la salle
          val = rooms_index.find_index(val) # index de la salle correspondante
          val = val ? rooms_names[val] : '' # Si on a pas réussi à trouver de salle
        when 'day'
          # Passe de lundi ... samedi à 0-6
          days = {'lundi' => 0, 'mardi' => 1, 'mercredi' => 2,
                  'jeudi' => 3, 'vendredi' => 4, 'samedi' => 5}
          val = days[val] || 0
        when 'start', 'end'
          # De "19:30" à [19, 30]
          val = val.split(':')
          val = val.size == 1 ? [0, 0] : val.map(&:to_i) # Format spécial
      end

      tmp_hash.merge!({translation => val})
    end
    tmp_hash
  end

  # Rassembler les mêmes horaires en mettant la liste des étudiants dedans

  # Attributs formants un identifiant de l'horaire, ex: TC201AM01TD11701860
  uniq_id = ['weekname', 'room', 'uv', 'type', 'day', 'start', 'end']
  # On rassemble les horaires ayant le même login
  timesheets = timesheets.group_by {|ts| uniq_id.map{|id| ts[id]}.join }
  # Met ça sous le format normal avec les logins des étudiants dans "students"
  timesheets = timesheets.map do |ts|
    ts = ts.last # Horaires depuis [TC201AM01TD11701860, [horaire, horaire, ...]]
    students = ts.map{|t| t['students']} # logins des étudiants
    ts = ts.first # Toutes les horaires sont les mêmes, on prend la première
    ts['students'] = students # On met les logins des étudiants
    ts
  end

  File.open(DB_FILE, 'w+') {|f| f.write(Marshal.dump(timesheets))}
end
