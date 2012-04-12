# encoding: utf-8

require 'mysql2'
require 'readline'

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
        'etu_id' => 'students', # ['mariedor', 'thevenin' ...]
        'uv' => 'uv', # MTX2, LE08
        'type' => 'type', # TD, CM, TP
        'jour' => 'day', # lundi, mardi, mercredi, jeudi, vendredi, samedi => 0..6
        'debut' => 'start', # 8:0, 14:0, 8:30 => [8, 0], ...
        'fin' => 'end', # 19:30, 10:60, 8:60 => [19, 30], ...
      }

      PROFILES = Profile.all # Évite les requêtes SQL

      # Trouver l'étudiant par rapport à son ID (pas forcement correct (9999)),
      # son prénom/nom coupé, sa branche et éventuelement peut recourir à une
      # manipulation humaine... mais ne devrait pas
      # Retourne le login de l'étudiant
      def find_student_with(ts)
        id = ts['etu_id'].to_i
        uv = ts['uv']
        level = ts['branche']
        names = ts['nom_prenom'].split(' ') || [] # FOUQUET JU, COLSON VAL, ...
        names.push('') while names.size < 2
        reg_names = names.map{|n| /^#{Regexp.escape(n)}/i }

        if id < 99000 # IDs inexistants
          # Recherche par ID étudiant
          profile = PROFILES.detect {|p| p.utt_id.to_i == id }
          if !profile.nil? and !profile.user.nil? and !profile.user.login.nil?
            return profile.user.login
            return profile.user.login
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
        if profiles.size > 1
          new = profiles.select {|p| p.firstname =~ reg_names[1] }
          profiles = new if new.size > 1
        end

        if profile.nil? or profile.empty?
          # FIXME: Avec les bons emplois du temps, on cherchera à tout
          #        tout prix à trouver quelqu'un, là pour les tests on
          #        ignore les étudiants non trouvés
          # puts "No students found for #{uv} : #{id} #{level} #{names.join(' ')}"
          return '' # TODO: Proposer un choix plus large
        elsif profiles.size == 1
          puts "On a trouve quelqu'un !"
          return profiles.first.user.login
        else
          puts 'Choose between students found :'
          puts "Indices : #{uv} : #{id} #{level} #{names.join(' ')}"
          profiles.each{|profile| puts "#{profile.user.login} : #{profile.level}" }
          login = Readline.readline('> ')
          return login
        end
      end

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

      puts "Translate timesheets to a nice hash"
      # Tableau de hash (traduction noms des champs, et parsage des valeurs)
      timesheets = timesheets.map do |ts|
        tmp_hash = Hash.new

        student = find_student_with(ts)

        if student.empty?
          print 'F'
          next nil
        end

        attrs.each do |attr, translation|
          val = ts[attr] # Récupére la valeur

          case translation
            when 'week'
              val = val.to_i # 1 ou 2
            when 'students'
              # Trouver l'étudiant par rapport aux indices laissés par l'UTT...
              val = student
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

      timesheets = timesheets.compact

      # Rassembler les mêmes horaires en mettant la liste des étudiants dedans
      puts "Group students by timesheet..."
      # Attributs formants un identifiant de l'horaire, ex: TC201AM01TD11701860
      uniq_id = ['weekname', 'room', 'uv', 'type', 'day', 'start', 'end']
      # On rassemble les horaires ayant le même login
      timesheets = timesheets.group_by {|ts| uniq_id.map{|id| ts[id]}.join }
      # Met ça sous le format normal avec les logins des étudiants dans "students"
      timesheets = timesheets.map do |ts|
        ts = ts.last # Horaires depuis [TC201AM01TD11701860, [horaire, horaire, ...]]

        # logins des étudiants
        students = ts.map{|t| t['students']}

        ts = ts.first # Toutes les horaires sont les mêmes, on prend la première
        ts['students'] = students  # On met les logins des étudiants trouvés
        ts
      end

      File.open(DB_FILE, 'w+') {|f| f.write(Marshal.dump(timesheets))}
    end
  end
end
