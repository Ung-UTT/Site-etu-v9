namespace :import do
  desc "Import ALL data (takes a while...)"
  task :full, :sure do |t, args|
    unless args[:sure] == 'yes-i-have-coffee'
      puts 'Are you crazy? Do-you-have-coffee?'
      exit 1
    end

    sh %{rake import:users:insert import:users:add_photos import:schedules:insert import:v7:mysql --trace}
  end
end

