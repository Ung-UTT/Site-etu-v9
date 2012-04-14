require 'mysql2'

namespace :import do
  desc "Import data, of the student website v7, from old MySQL database"
  task :v7 => :environment do
    client = Mysql2::Client.new(
      :host => 'localhost',
      :username => 'root',
      :password => 'lol',
      :database => 'v7'
    )

    puts "Loading dumps into DB..."
    Dir[File.join(File.dirname(__FILE__), 'data/*.sql')].each do |file|
      puts file
      system "mysql -uroot -plol v7 < #{file}"
    end

    print "Importing users..."
    [
      client.query("SELECT * FROM usersInfo ORDER BY dateCreation LIMIT 20"),
      client.query("SELECT * FROM usersInfo WHERE login IN ('felizarc', 'mariedor')") # FIXME
    ].each do |results|
      results.each(:symbolize_keys => true) do |row|
        # next unless row[:actif] == 'Y'
        user = User.find_by_login(row[:login]) || User.simple_create(row[:login])
        user.email = (row[:email].blank? ? "#{row[:login]}@utt.fr" : row[:email])
        user.created_at = row[:dateCreation]
        user.save

        unless row[:prenom].empty? # real people seem to have a "prenom"
          profile = Profile.create(
            :user_id => user.id,
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
          )
        end
        print '.'
      end
    end
    puts

    print "Importing quotes..."
    results = client.query("SELECT * FROM citation ORDER BY id LIMIT 20") # FIXME
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
        :owner_id => Profile.all.detect do |profile|
            "#{profile.firstname} #{profile.lastname}" == row[:nom_responsable]
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
        :user_id => User.find_by_login(row[:auteur_login]),
        :is_moderated => true,
        :created_at => row[:date_creation]
      )
      print '.'
    end
    puts

    # TODO: import other data

    puts "Done."
  end
end

