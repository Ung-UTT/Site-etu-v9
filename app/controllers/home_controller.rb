class HomeController < ApplicationController
  skip_authorization_check

  def index
    @news = News.all
  end
end
