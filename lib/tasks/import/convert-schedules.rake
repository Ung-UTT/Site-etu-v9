# encoding: utf-8

require 'mysql2'
require Rails.root.join('lib', 'find_student')

namespace :import do
  namespace :schedules do
    desc "Convert schedules from the UTT export (need MySQL database with schedules)"
    task :convert do
      DB_FILE = Rails.root.join('tmp', 'schedule.marshal')
      TIMESHEETS_TABLE = 'export_UNGA11'

      # Convertit les exports de la base SQL de l'UTT en un fichier .marshal
      # qui est un hash de trois tableaux : horaires, salles et utilisateurs

      # À partir des fichiers .sql reçus, il faut les importer dans une base
      # MySQL

      # Le but est à partir des tables hideuses fournies on arrive à un hash
      # des propriétés utiles bien présentées

      # Attributs à traduire
      attrs = {
        'weekname' => 'weekname', # T, A, B
        'semaine' => 'week', # 1, 2 : toutes les semaines, ou 1 semaine sur 2 # FIXME : utile ?
        'id' => 'room', # C101, A002, ...
        'students' => 'students', # ['mariedor', 'thevenin' ...]
        'uv' => 'uv', # MTX2, LE08
        'type' => 'type', # TD, CM, TP
        'jour' => 'day', # lundi, mardi, mercredi, jeudi, vendredi, samedi => 0..6
        'debut' => 'start', # 8:0, 14:0, 8:30 => [8, 0], ...
        'fin' => 'end', # 19:30, 10:60, 8:60 => [19, 30], ...
      }

      puts 'Get schedules'
      if File.exists?(DB_FILE)
        puts "The file #{DB_FILE.to_s} already exists, you can now import " +
             "the schedules"
        exit
      end

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
      rooms_index = []
      rooms_names = []
      query.each(:as => :array) do |room|
        # Sépare les index et les noms
        rooms_index.push(room[0])
        rooms_names.push(room[1])
      end

      # Récupére les horaires
      timesheets = base.query("SELECT * FROM #{TIMESHEETS_TABLE}").to_a

      # Met les seules infos qu'on a sur lui dans un tableau
      timesheets = timesheets.map{|t| t['student'] = [t['etu_id'], t['nom_prenom'], t['branche']]; t}

      # Va chercher les vrais utilisateurs via les indices laissés
      puts "Find students..."
      users = timesheets.map {|t| t['student'] }.uniq
      users = users.map {|u| [u, find_student(u[0], u[1], u[2])]}

      # Rassembler les mêmes horaires en mettant la liste des étudiants dedans
      puts "Group students by timesheet..."
      # On rassemble les horaires ayant le même login
      timesheets = timesheets.group_by {|ts| ts['id'] }.map{|ts| ts.last}

      puts "Translate timesheets to a nice hash"
      # Tableau de hash (traduction noms des champs, et parsage des valeurs)
      timesheets = timesheets.map do |ts|
        # Retrouve les logins des étudiants via le tableau les identifiant
        students = ts.map{|t| users.detect{|u| u.first == t['student']}.last }

        ts = ts.first # Toutes les horaires sont les mêmes, on prend la première
        # On met les logins des étudiants trouvés
        ts['students'] = students.uniq.select{|s| !s.empty?}

        tmp_hash = Hash.new

        attrs.each do |attr, translation|
          val = ts[attr] # Récupére la valeur

          case translation
            when 'week'
              val = val.to_i # 1 ou 2
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
              val = val.split(':') || [0, 0]
              val = val.size == 1 ? [0, 0] : val.map(&:to_i) # Format spécial
          end

          tmp_hash.merge!({translation => val})
        end
        print '.'
        tmp_hash
      end
      puts

      puts "Write data to : #{DB_FILE}"
      # Écrit directement en BINARY mode pour éviter les problèmes d'encodage
      File.open(DB_FILE, 'wb+') {|f| f.write(Marshal.dump(timesheets))}
    end
  end
end
