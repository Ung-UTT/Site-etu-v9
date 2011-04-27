class HomeController < ApplicationController
  def index
    @news = News.all
  end
end
