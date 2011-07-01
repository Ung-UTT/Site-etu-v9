class UserMailer < ActionMailer::Base
  default :from => "bde@utt.fr"
  
  def daymail(user)
    @user = user
    @news = News.where('created_at > ?', Time.now - 1.day)
    @date = I18n.l(Date.today, :format => :long)
    mail(:to => user.email,
         :subject => '[Daymail] ' + @date)
  end
end

