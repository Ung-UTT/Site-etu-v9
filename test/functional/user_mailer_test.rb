require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  def test_daymail
    user = users(:joe)
    news = news(:omg)
    news.created_at = Time.now
    news.save
 
    # Send the email, then test that it got queued
    email = UserMailer.daymail(user).deliver
    assert !ActionMailer::Base.deliveries.empty?
 
    # Test the body of the sent email contains what we expect it to
    assert_equal [user.email], email.to
    assert_match /\[Daymail\]/, email.subject
    assert_match /#{user.login}/, email.encoded
  end
end
