require 'spec_helper'

feature "Managing news" do
  scenario "Submitting a news" do
    login, password = 'toto', 'superpass'
    user = create :student, login: login, password: password

    sign_in login, password
    visit new_news_path

    form = find("//form[@action=\"/news\"]")
    within(form) do
      fill_in :title, with: "Yo yo yo, y pleut des haricots"
      fill_in :content, with: <<-CONTENT
        Howto
        ======

        1. Eviter les haricots
        2. ???
        3. Profit
      CONTENT
      submit_form
    end

    current_path.should == news_index_path
    page_should_have_notice
  end

  scenario "Moderating a news" do
    news = create :news, is_moderated: false
    login, password = 'modo', 'superpass'
    user = create :moderator, login: login, password: password

    sign_in login, password
    visit news_path(news)
    find_link(I18n.t('newss.moderate')).click

    current_path.should == edit_news_path(news)
    form = find("//form[@action=\"#{news_path(news)}\"]")
    within(form) do
      check 'news_is_moderated'
      submit_form
    end

    current_path.should == news_path(news)
    page_should_have_notice
    page.should_not have_link I18n.t('newss.moderate')
    page.should have_content news.title
  end
end

