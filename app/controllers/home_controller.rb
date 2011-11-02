class HomeController < ApplicationController
  skip_authorization_check

  def index
    @news = News.page(params[:page])
  end

  def about
  end
end
