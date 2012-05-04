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

      # temporary user used for import
      import_user = User.find_by_login('import') || User.simple_create('import')

      print "Importing users (may take a while)..."
      users = client.query("SELECT * FROM usersInfo ORDER BY dateCreation")

      ActiveRecord::Base.transaction do
        users.each(:symbolize_keys => true) do |row|
          row[:email] = "#{row[:login]}@utt.fr" if row[:email].blank?

          # import only existing users from LDAP
          if user = User.find_by_login_and_email(row[:login], row[:email])
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
                $stderr.puts "#{user.login}##{key}: overriding #{old_value.inspect} with #{value.inspect}"
                user.send "#{key}=", value
              end
            end

            user.save
            print '.'
          end
        end
      end
      puts

      print "Importing quotes..."
      results = client.query("SELECT * FROM citation ORDER BY id")
      results.each(:symbolize_keys => true) do |row|
        next unless row[:active] == 1
        next if row[:source] == 'wikipedia'
        next if Quote.find_by_content(row[:text])
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
        next if Asso.find_by_name(row[:intitule])
        asso = Asso.create(
          :name => row[:intitule],
          :website => row[:web],
          :email => row[:email],
          :description => row[:description],
          :owner_id => User.all.detect do |user|
              "#{user.firstname} #{user.lastname}" == row[:nom_responsable]
            end.try(:id) || import_user.id
        )
        print '.'
      end
      puts

      # dependencies: users
      print "Importing news..."
      results = client.query("SELECT * FROM news_liste ORDER BY id_news")
      results.each(:symbolize_keys => true) do |row|
        next if News.find_by_title_and_content(row[:titre], row[:information])
        news = News.new(
          :title => row[:titre],
          :content => row[:information],
          :is_moderated => true
        )
        news.user = User.find_by_login(row[:auteur_login])
        news.created_at = row[:date_creation]
        news.save
        print '.'
      end
      puts

      # dependencies: users, courses
      print "Importing course comments (may take a while)..."
      results = client.query("SELECT * FROM users_uvs ORDER BY annee")

      ActiveRecord::Base.transaction do
        results.each(:symbolize_keys => true) do |row|
          next if row[:eval].blank?

          course = Course.find_by_name(row[:uv]) || Course.create!(name: row[:uv])
          next if course.comments.find_by_content_and_created_at(row[:eval], row[:date_eval])

          comment = course.comments.new(
            :content => row[:eval],
            # :grade => row[:eval_note] # FIXME
          )
          comment.created_at = row[:date_eval]
          comment.save
          print '.'
        end
      end
      puts

      # TODO: import moar data!

      puts "Done."
      puts "Don't forget to set unknown assos' owners manually then delete the 'import' user!"
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

