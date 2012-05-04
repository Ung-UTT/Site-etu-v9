class UserMailer < ActionMailer::Base
  default from: "bde@utt.fr"

  def daymail(user, content)
    @user, @content = user, content
    @date = I18n.l(Date.today, format: :long)

    mail(to: user.email, subject: "[Daymail] #{@date}") do |format|
      format.html
      format.text
    end
  end

  def error(error)
    @error = error

    mail(
      from: "ung+bug-site-etu@utt.fr",
      to: User.administrators.map(&:email),
      subject: "[Site-etu] [Bug] #{@error.message}"
    )
  end
end

