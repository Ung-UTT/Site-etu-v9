#!/usr/bin/env ruby

# Convertit les exports de la base SQL de l'UTT en un fichier .marshal
# qui est un hash de trois tableaux : horaires, salles et utilisateurs

# À partir des fichiers .sql reçus, il faut les importer dans une base
# MySQL

# Le but est à partir des tables hideuses fournies on arrive à un hash
# des propriétés utiles bien présentées

require 'mysql' # Il faut installer libmysql-ruby sur Ubuntu

DB_FILE = 'data/schedule.marshal'

# Nom de la table des horaires
TIMESHEETS_TABLE = 'export_UNGA11'

# Attributs à traduire
attrs = {
  'weekname' => 'weekname', # T, A, B
  'semaine' => 'week', # 1, 2 : toutes les semaines, ou 1 semaine sur 2
  'id' => 'room', # C101, A002, ...
  'etu_id' => 'etu_id', # 12030, ...
  'uv' => 'uv', # MTX2, LE08
  'type' => 'type', # TD, CM, TP
  'jour' => 'day', # lundi, mardi, mercredi, jeudi, vendredi, samedi
  'debut' => 'start', # 8:0, 14:0, 8:30
  'fin' => 'end', # 19:30, 10:60, 8:60
}

puts 'Récupération des emplois du temps des étudiants'
if File.exists?(DB_FILE)
  puts "Utilisation de #{BD_FILE.to_s}"
  students = Marshal.load(File.read(DB_FILE))
else
  begin
    # Connexion : serveur, utilisateur, mdp, base
    base = Mysql.real_connect('localhost', 'utt_edt', 'utt_edt', 'utt_edt')
  rescue
    puts 'Impossible de se connecter au serveur MySQL'
    exit
  end

  # Récupére les salles
  query = base.query('SELECT * FROM rel_seance_salle')
  rooms = []
  while room = query.fetch_row do
    rooms.push(room)
  end
  # Sépare les index et les noms
  rooms_index = rooms.map{|r| r[0]}
  rooms_names = rooms.map{|r| r[1]}

  # Récupére les horaires
  query = base.query("SELECT * FROM #{TIMESHEETS_TABLE}")
  timesheets = []
  while ts = query.fetch_hash do
    timesheets.push(ts)
  end

  base.close if base # Déconnexion

  # Tableau de hash (traduction noms des champs, et parsage des valeurs)
  timesheets = timesheets.map do |ts|
    tmp_hash = Hash.new
    attrs.each do |attr, translation|
      val = ts[attr] # Récupére la valeur

      case translation
        when 'week', 'etu_id'
          val = val.to_i
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

  File.open(DB_FILE, 'w+') {|f| f.write(Marshal.dump(timesheets))}
end
