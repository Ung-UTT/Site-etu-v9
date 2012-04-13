class UserMailer < ActionMailer::Base
  default :from => "bde@utt.fr"

  def daymail(user, content)
    @user, @content = user, content
    @date = I18n.l(Date.today, :format => :long)

    mail(:to => user.email, :subject => '[Daymail] ' + @date) do |format|
      format.html
      format.text
    end
  end

  def password_reset(user)
    @user = user
    mail(:to => user.email,
         :subject => t('mailers.user.password_reset.subject'))
  end
end

