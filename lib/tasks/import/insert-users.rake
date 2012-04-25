namespace :import do
  namespace :users do
    desc "Insert users in the database"
    task :insert => :environment do
      require 'net-ldap' # Sinon : undefined class/module Net::BER::

      DB_FILE = File.join(File.dirname(__FILE__), 'data', 'ldap.marshal')

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
end
