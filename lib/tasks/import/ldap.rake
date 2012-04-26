namespace :import do
  namespace :users do
    desc "Insert users in the database"
    task :insert => :environment do
      require 'net-ldap' # Sinon : undefined class/module Net::BER::

      DB_FILE = File.join(File.dirname(__FILE__), 'data', 'ldap.marshal')

      if File.exists?(DB_FILE)
        puts "Get students informations from #{DB_FILE}"
        students = Marshal.load(File.open(DB_FILE, 'rb').read)
      else
        puts "You have to convert users first"
        exit
      end

      puts "Add students to the database"
      ActiveRecord::Base.transaction do # Permet d'être beaucoup plus rapide !
        students.each do |st|
          puts "#{st['supannetuid']} : #{st['displayname']}"

          # Créer ou mettre à jour
          u = User.find_by_login(st['uid']) || User.new(:login => st['uid'])
          u.password = u.password_confirmation = SecureRandom.base64

          # E-Mail
          u.email = st['mail']
          if u.email.nil? or u.email.empty?
            u.email = "#{u.login}@utt.fr" # Mieux que rien (pour deux personnes...)
          end

          # On va écrire les détails dans le profil (le crée s'il ne l'est pas déjà)
          u.build_profile unless u.profile

          # Photo de profil
          begin
            picture = Image.from_url(st['jpegphoto'])
          rescue => e
            puts e.inspect # Pas internet, 404, etc...
          end

          u.profile.image = Image.new(:asset => picture) unless picture.nil?

          u.profile.utt_id = st['supannetuid'].to_i
          u.profile.firstname = st['givenname']
          u.profile.lastname = st['sn']
          u.profile.level = st['niveau']
          u.profile.specialization = st['filiere']
          u.profile.role = st['employeetype']
          u.profile.phone = st['telephonenumber']
          u.profile.room = st['roomnumber']

          # Les UVs sont ajoutées via les emploi du temps
          # (Un utilisateur suit un cours si il participe à au moins une horaire)

          u.become_a!(:utt) # assuming all imported users have a CAS account

          # Ajouter le rôle d'étudiant si il l'est
          u.become_a!(:student) if st['employeetype'] == 'student'

          # On sauvegarde le tout
          unless u.save
            puts u.errors.inspect
          end
        end
      end
    end
  end

  namespace :schedules do
    desc "Insert schedules in the database (need schedule.marhsal from conversion)"
    task :insert => :environment do
      # Dans le dossier temporaire de Rails
      DB_FILE = Rails.root.join('tmp', 'schedule.marshal')

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
            # Durée : fin - début (heures et minutes)
            :duration => (ts['end'][0] - ts['start'][0])*60 +
                          ts['end'][1] - ts['start'][0],
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
          ids = [:start_at, :duration, :week, :room, :category, :course_id]
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

