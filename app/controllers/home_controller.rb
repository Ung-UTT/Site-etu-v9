class HomeController < ApplicationController
  skip_authorization_check

  def index
    @news = News.order('created_at desc')
  end
end
