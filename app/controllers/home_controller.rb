class HomeController < ApplicationController
  skip_authorization_check

  def index
    @news = current_news
  end

  def newspaper
    # TODO: News associées à l'association N'UTT
    @news = current_news.select { |n| n.title.match('Journal') }
  end

  def about
  end
end
