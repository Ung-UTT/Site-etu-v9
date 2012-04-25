# encoding: utf-8

require 'readline'

namespace :import do
  namespace :schedules do
    desc "Convert schedules from the UTT export (need MySQL database with schedules)"
    task :convert => :environment do
      require 'mysql2'

      DB_FILE = Rails.root.join('tmp', 'schedule.marshal')
      TIMESHEETS_TABLE = 'vue_edt_etu'

      # Convertit les exports de la base SQL de l'UTT en un fichier .marshal
      # qui est un hash de trois tableaux : horaires, salles et utilisateurs

      # À partir des fichiers .sql reçus, il faut les importer dans une base
      # MySQL

      # Le but est à partir des tables hideuses fournies on arrive à un hash
      # des propriétés utiles bien présentées

      # Attributs à traduire
      attrs = {
        'weekname' => 'weekname', # T, A, B
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
        if id < 99000 # IDs existants vraiment
          # Recherche par ID étudiant
          profile = PROFILES.detect {|p| p.utt_id == id }
          if !profile.nil? and !profile.user_id.nil?
            print '.'
            return find_user(profile.user_id)
          end
        end

        # Recherche par élimination : branche, nom, prénom
        profiles = PROFILES.select {|p| p.level == level}
        profiles = PROFILES if profiles.empty? # Branche qui n'existe pas :D (CV01, ...)

        # Recherche par combinaisons des indices (nom et prénom découpés)
        # On récupére les indices que l'on tri par taille et que l'on met
        # en Regexp
        clues = names.split.sort{|c1,c2| c2.size <=> c1.size}.map do |c|
          /#{Regexp.escape(c)}/i
        end
        # Recherche de plus en plus précise (au mieux l'étudiant a tout les indices
        clues.each do |clue|
          new = profiles.select do |p|
            p.firstname =~ clue || p.lastname =~ clue
          end
          profiles = new unless new.empty?
        end

        if profiles.nil? or profiles.empty? or profiles.size > 200
          puts
          puts "Can't find #{names} (level : #{level}), you should find" <<
               "a way to find this student and write his login below :"
          puts Readline.readline('> ')
        elsif profiles.size == 1
          print '|' # Mieux qu'un point... une barre :D
          return find_user(profiles.first.user_id)
        else
          begin
            puts
            puts 'Choose between students :'
            puts "Clues : #{names}"
            profiles.each do |p|
              puts "_ #{profiles.index(p) + 1} : #{p.firstname} #{p.lastname} (#{p.user.login})"
            end
            index = Readline.readline('> ').to_i - 1
            puts "Vous devez mettre un nombre valide" if index == -1
          end while index == -1 # Gestion des erreurs (si l'utilisateur tape le login)
          login = profiles[index].user.login
          return login
        end
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
      users = users.map {|u| [u, find_student(u[0], u[1].downcase, u[2])]}
      puts

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
