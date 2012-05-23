desc 'Envoi le Daymail'
task daymail: :environment do
  content = {}
  content[:news] = News.where('created_at > ?', Time.now - 1.day)
  return if content.values.all?(&:empty?) # don't send an empty daymail

  User.students.each do |student|
    UserMailer.daymail(student, content).deliver
  end
end
