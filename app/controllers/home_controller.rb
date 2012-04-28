# encoding: utf-8

class HomeController < ApplicationController
  skip_authorization_check

  def index # Page d'accueil
    @news = News.visible.page(1)
  end

  def about
  end

  def rules
  end
end
