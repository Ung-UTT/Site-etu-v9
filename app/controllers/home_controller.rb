# encoding: utf-8
class HomeController < ApplicationController
  skip_authorization_check

  def index
    @news = News.where(:is_moderated => true).page(params[:page])
  end

  def about
  end
end
