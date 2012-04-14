require 'net-ldap'

namespace :import do
  namespace :users do
    desc "Insert users in the database"
    task :insert => :environment do
      DB_FILE = Rails.root.join('tmp', 'ldap.marshal')

      if File.exists?(DB_FILE)
        puts "Get students informations from #{DB_FILE}"
        students = Marshal.load(File.read(DB_FILE))
      else
        puts "You have to convert users first"
        exit
      end

      puts "Add students to the database"
      ActiveRecord::Base.transaction do # Permet d'être beaucoup plus rapide !
        students.each do |st|
          puts "#{st['supannetuid']} : #{st['displayname']}"

          # Créer ou mettre à jour
          u = User.find_by_login(st['uid']) || User.simple_create(st['uid'])

          # E-Mail
          u.email = st['mail']
          if u.email.nil? or u.email.empty?
            u.email = "#{u.login}@utt.fr" # Mieux que rien (pour deux personnes...)
          end

          # On va écrire les détails dans le profil (le crée s'il ne l'est pas déjà)
          u.build_profile.save unless u.profile

          # Photo de profil
          if false # FIXME: Trop long avec les photos... faut les télécharger à part
          begin
            picture = Image.from_url(st['jpegphoto'])
          rescue => e
            puts e.inspect
            puts "No photo because there is no internet access"
            picture = nil
          end

          u.profile.image = Image.new(:asset => picture) if picture
          end

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

          # Ajouter le rôle d'étudiant si il l'est
          u.become_a_student if st['employeetype'] == 'student'

          # On sauvegarde le tout
          unless u.save
            puts u.errors.inspect
          end
        end
      end
    end
  end
end
