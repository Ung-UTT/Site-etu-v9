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
end

