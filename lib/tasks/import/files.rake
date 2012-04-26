namespace :import do
  desc "Import data, of the student website v7, from file sharings"
  task :files => :environment do
    DIR = '/tmp/annals'

    unless File.directory? DIR
      puts "Mount the shared directory before (using sshfs)."
      exit 1
    end

    `find /tmp/annals -name \*.pdf`.lines do |line|
      if annal = line.match(/\/(?<course>[^\/]*)_(?<semester>[AP])(?<year>[0-9]{2})_(?<type>.)\.pdf\Z/)
        if course = Course.find_by_name(annal[:course])
          puts Annal.create!(
            course: course,
            year: annal[:year],
            semester: annal[:semester]
          )
        else
          puts "Unknown course #{annal[:course]}, ignoring annals."
        end
      end
    end
  end
end

