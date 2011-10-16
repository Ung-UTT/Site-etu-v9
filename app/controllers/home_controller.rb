class HomeController < ApplicationController
  skip_authorization_check

  def index
    @news = current_news
  end

  def about
  end
end
