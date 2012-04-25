namespace :import do
  namespace :schedules do
    desc "Insert schedules in the database (need schedule.marhsal from conversion)"
    task :insert => :environment do
      DB_FILE = File.join(File.dirname(__FILE__), 'data', 'schedule.marshal')

      # Attributs dans le fichier convertit :
      #   "weekname" : T, A, B
      #   "room" : C101, A002, ...
      #   "students" : ['mariedor', 'thevenin', ...]
      #   "uv" : MTX2, LE08
      #   "type" : TD, CM, TP
      #   "day" : 0..6 (lundi..samedi)
      #   "start" : [8, 0], ...
      #   "end" : [19, 30], ...

      if File.exists?(DB_FILE)
        puts "Use #{DB_FILE.to_s}"
        # Ouvre le fichier en BINARY mode à cause de problèmes d'encodage
        timesheets = Marshal.load(File.open(DB_FILE, 'rb').read)
      else
        puts "You must convert schedules first"
        exit
      end

      USERS = User.all # Économise des requêtes SQL

      ActiveRecord::Base.transaction do # Permet d'être beaucoup plus rapide !
        timesheets.each do |ts|
          print '.'

          # Créer l'horaire
          new = Timesheet.new(
            # Date du premier cours (on sait pas donc première semaine de rentrée
            :start_at => SEMESTERS.last['start_at'] + ts['day'].days +
                         ts['start'][0].hours + ts['start'][1].minutes,
            :end_at => SEMESTERS.last['start_at'] + ts['day'].days +
                       ts['end'][0].hours + ts['end'][1].minutes,
            # Semaine A, semaine B ou rien
            :week => ts['weekname'] == 'T' ? nil : ts['weekname'],
            :room => ts['room'], # Salle
            :category => ts['type'], # CM, TD, TP
            # Crée le cours s'il n'existe pas
            :course => Course.find_or_create_by_name(ts['uv'])
          )

          # Horaires possibles
          timesheets = Course.find_by_name(ts['uv']).timesheets

          # Si l'horaire existe déjà, la choisir
          ids = [:start_at, :end_at, :week, :room, :category, :course_id]
          timesheet = timesheets.detect do |t|
            ids.map{|id| t[id] == new[id]}.uniq == [true]
          end

          # Sinon la créer
          if timesheet.nil?
            timesheet = new
            timesheet.save
          end

          # Trouver les étudiants
          if ts['students'].empty?
            puts 'No students for this timesheet'
            next
          end

          users = USERS.select {|user| ts['students'].include?(user.login)}
          if users.size != ts['students'].size
            # Ne devrait jamais arriver
            puts "\nSome students can't be found for #{timesheet.short_range}"
          end

          # Ajouter l'horaire aux étudiants
          users.each do |user|
            user.timesheets << timesheet
          end
        end
        puts
        puts "Done"
      end
    end
  end
end
