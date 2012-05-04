namespace :import do
  namespace :v7 do
    desc "Import data, of the student website v7, from old MySQL database"
    task :mysql => :environment do
      require 'mysql2'

      client = Mysql2::Client.new(
        :host => 'localhost',
        :username => 'utt_db',
        :password => 'utt_db',
        :database => 'utt_db'
      )

      puts "Loading dumps into DB..."
      Dir[File.join(File.dirname(__FILE__), 'data/*.sql')].each do |file|
        puts file
        system "mysql -uutt_db -putt_db utt_db < #{file}"
      end

      print "Importing users..."
      ActiveRecord::Base.transaction do
        # real people seem to have a "prenom"
        real_users = client.query("SELECT * FROM usersInfo WHERE prenom != '' ORDER BY dateCreation")

        real_users.each(:symbolize_keys => true) do |row|
          user = User.find_by_login(row[:login]) || User.simple_create(row[:login])
          user.email = (row[:email].blank? ? "#{row[:login]}@utt.fr" : row[:email])

          {
            :created_at => row[:dateCreation],
            :firstname => row[:prenom],
            :lastname => row[:nom],
            :surname => row[:surnom],
            :once => row[:jadis],
            :utt_id => row[:idEtu].to_i,
            :level => row[:branche],
            :specialization => row[:filiere],
            :role => row[:LDAPdescription],
            :phone => row[:gsm],
            :utt_address => %w[
              adr_3_rue adr_3_ville adr_3_cp adr_3_pays
            ].map{|i| row[i.to_sym]}.join(' '),
            :parents_address => %w[
              adr_p_rue adr_p_ville adr_p_cp adr_p_pays
            ].map{|i| row[i.to_sym]}.join(' ')
          }.each do |key, value|
            value.strip! if value.is_a? String
            value = nil if value == ''
            old_value = user.send key
            if old_value != value and !value.nil?
              puts "#{user.login}##{key}: overriding #{old_value.inspect} with #{value.inspect}"
              user.send "#{key}=", value
            end
          end

          user.save
        end
      end
      puts

      print "Importing quotes..."
      results = client.query("SELECT * FROM citation ORDER BY id")
      results.each(:symbolize_keys => true) do |row|
        next unless row[:active] == 1
        quote = Quote.create(
          :content => row[:text],
          :tag => (row[:source] == 'humour' ? 'joke' : row[:source]),
          :author => row[:more]
        )
        print '.'
      end
      puts

      # dependencies: users
      print "Importing assos & clubs..."
      results = client.query("SELECT * FROM club_asso ORDER BY id")
      results.each(:symbolize_keys => true) do |row|
        next if row[:type] == 0 # deleted asso
        asso = Asso.create(
          :name => row[:intitule],
          :website => row[:web],
          :email => row[:email],
          :description => row[:description],
          :owner_id => User.all.detect do |user|
              "#{user.firstname} #{user.lastname}" == row[:nom_responsable]
            end.try(:user_id) || User.find_by_login('admin').id
        )
        print '.'
      end
      puts

      # dependencies: users
      print "Importing news..."
      results = client.query("SELECT * FROM news_liste ORDER BY id_news")
      results.each(:symbolize_keys => true) do |row|
        news = News.create!(
          :title => row[:titre],
          :content => row[:information],
          :user => User.find_by_login(row[:auteur_login]),
          :is_moderated => true,
          :created_at => row[:date_creation]
        )
        print '.'
      end
      puts

      # dependencies: users, courses
      print "Importing course comments..."
      results = client.query("SELECT * FROM users_uvs ORDER BY annee")
      results.each(:symbolize_keys => true) do |row|
        next if row[:eval].blank?

        course = Course.find_by_name(row[:uv]) || Course.create!(name: row[:uv])

        course.comments.create!(
          :user => User.find_by_login(row[:login]),
          :content => row[:eval],
          # :grade => row[:eval_note], # FIXME
          :created_at => row[:date_eval]
        )
        print '.'
      end
      puts

      # TODO: import moar data!

      puts "Done."
    end


    desc "Import data, of the student website v7, from file sharings"
    task :files => :environment do
      DIR = '/tmp/annals'

      unless File.directory? DIR
        puts "Mount the shared directory before (using sshfs)."
        exit 1
      end

      `find #{DIR} -name \*.pdf`.lines do |line|
        if annal = line.match(/\/(?<course>[^\/]*)_(?<semester>[AP])(?<year>[0-9]{2})_(?<type>.)\.pdf\Z/)
          if course = Course.find_by_name(annal[:course])
            puts Annal.create!(
              course: course,
              year: annal[:year],
              semester: annal[:semester],
              document: File.open(annal, 'rb').read
            )
          else
            puts "Unknown course #{annal[:course]}, ignoring annals."
          end
        end
      end
    end
  end
end

