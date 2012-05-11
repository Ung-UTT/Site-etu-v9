require 'spec_helper'

feature "Managing news" do
  scenario "Submitting a news" do
    user = create :student

    sign_in user.login, user.password
    visit new_news_path

    within_form do
      fill_in :title, with: "Yo yo yo, y pleut des haricots"
      fill_in :content, with: <<-CONTENT
        Howto
        ======

        1. Eviter les haricots
        2. ???
        3. Profit
      CONTENT

      expect {
        submit_form
      }.to change{News.count}.by(1)
    end

    current_path.should == news_index_path
    page_should_have_notice
  end

  scenario "Moderating a news" do
    news = create :news, is_moderated: false
    user = create :moderator

    sign_in user.login, user.password
    visit news_path(news)
    find_link(I18n.t('newss.moderate')).click

    current_path.should == edit_news_path(news)
    within_form(action: news_path(news)) do
      check 'news_is_moderated'
      submit_form
    end

    current_path.should == news_path(news)
    page_should_have_notice
    page.should_not have_link I18n.t('newss.moderate')
    page.should have_content news.title
  end
end

