desc 'Envoi le Daymail'
task :daymail => :environment do
  User.all.each do |user|
    UserMailer.daymail(user)
  end
end
