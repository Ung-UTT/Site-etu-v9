namespace :import do
  desc "Import ALL data (takes a while...)"
  task :full, :sure do |t, args|
    unless args[:sure] == 'yes-i-have-coffee'
      puts 'Are you crazy?'
      exit 1
    end

    sh %{rake import:users:insert}
    sh %{rake import:schedules:insert}
    sh %{rake import:mysql}
    sh %{rake import:files}
  end
end

