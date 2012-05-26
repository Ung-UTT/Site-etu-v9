# encoding: utf-8

class HomeController < ApplicationController
  skip_authorization_check

  def index
    @news = News.visible.page(params[:page])
  end

  def about
  end

  def rules
  end
end
