desc 'Envoi le Daymail'
task :daymail => :environment do
  User.all.select{|u| u.student?}.each do |user|
    UserMailer.daymail(user)
  end
end
