# encoding: utf-8

namespace :import do
  namespace :users do
    desc "Insert users in the database"
    task :insert => :environment do
      require 'net-ldap' # Sinon : undefined class/module Net::BER::

      # Dans le dossier temporaire de Rails
      DB_FILE = Rails.root.join('tmp', 'users.marshal')

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
          print '.' # Un point par personne

          # Créer ou mettre à jour
          u = User.find_by_login(st['uid']) || User.new(:login => st['uid'])
          u.password = u.password_confirmation = SecureRandom.base64

          # E-Mail
          u.email = st['mail']
          if u.email.nil? or u.email.empty?
            u.email = "#{u.login}@utt.fr" # Mieux que rien (pour deux personnes...)
          end

          # On va écrire les détails dans le profil
          u.utt_id = st['supannetuid'].to_i
          u.firstname = st['givenname']
          u.lastname = st['sn']
          u.level = st['niveau']
          u.specialization = st['filiere']
          u.role = st['employeetype'].force_encoding('utf-8')
          u.phone = st['telephonenumber']
          u.room = st['roomnumber']

          # Les UVs sont ajoutées via les emploi du temps
          # (Un utilisateur suit un cours si il participe à au moins une horaire)

          # Ajouter le rôle d'étudiant si il l'est
          u.add_role('student') if st['employeetype'] == 'student'

          # On sauvegarde le tout
          begin
            unless u.save
              puts u.errors.inspect
            end
          rescue => e
            # Les seules erreurs qu'il reste sont des mails spéciaux
            # utilisés plusieurs fois
            puts
            puts "#{st['supannetuid']} : #{st['displayname']}"
            puts "Error: " + e.inspect
            puts "User: " + u.inspect
          end
        end
      end
    end

    desc "Ajoute les photos des utilisateurs"
    task :add_photos => :environment do
      require 'open-uri'

      DB_FILE = Rails.root.join('tmp', 'users.marshal')
      PHOTOS_DIR = Rails.root.join('tmp', 'photos')

      if File.exists?(DB_FILE)
        puts "Get students informations from #{DB_FILE}"
        students = Marshal.load(File.open(DB_FILE, 'rb').read)
      else
        puts "You have to convert users first"
        exit
      end

      # Télécharge les photos et les met dans le dossier tmp/photos

      # Crée le dossier si il ne l'est pas déjà
      Dir.mkdir(PHOTOS_DIR) unless File::directory?(PHOTOS_DIR)

      puts "Download photos :"
      # Seulement ceux qui ont des photos
      students = students.reject { |s| s['jpegphoto'].nil? }
      photos = students.map { |s| s['jpegphoto'] }

      threads = [] # Téléchargements en parallèle

      photos.each_slice(100) do |slice|
        # On télécharge les photos par 100
        slice.each do |photo|
          # Exemmple : tmp/photos/28765.jpg
          location = PHOTOS_DIR + photo.split('/').last
          unless File.exists?(location)
            threads << Thread.new(location, photo) do
              # On va chercher le fichier sur Internet et on l'enregistre
              begin
                file = open(location, "wb")
                file.write(open(photo).read)
                file.close
                print '.'
              rescue => e
                puts "\n" + e.inspect
              end
            end
          end
        end

        threads.each { |t| t.join } # Attend que les threads se terminent
      end

      puts "Add photos to users :"
      ActiveRecord::Base.transaction do # Permet d'être beaucoup plus rapide !
        students.each do |student|
          user = User.find_by_login(student['uid'])

          next if user.nil? # Pas encore importé

          print '.'

          # Va chercher l'image et l'ajoute au profil
          file = File.open(PHOTOS_DIR + student['jpegphoto'].split('/').last)
          user.image = Image.new(:asset => file)
          user.save
        end
      end
    end
  end
end

