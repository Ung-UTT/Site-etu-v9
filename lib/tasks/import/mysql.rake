require 'mysql2'

namespace :import do
  desc "Import data from old MySQL database"
  task :mysql => :environment do
    client = Mysql2::Client.new(
      :host => 'localhost',
      :username => 'root',
      :password => 'lol',
      :database => 'news'
    )

    News.delete_all
    puts "Importing news..."
    results = client.query("SELECT * FROM news_liste")
    results.each(:symbolize_keys => true) do |row|
      news = News.create!(
        :title => row[:titre],
        :content => row[:information],
        :is_moderated => true,
        :created_at => row[:date_creation]
      )
      puts news.inspect
    end

    # TODO: import other data

    puts "Done."
  end
end

