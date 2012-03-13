# encoding: utf-8

class HomeController < ApplicationController
  skip_authorization_check

  def index # Page d'accueil
    @news = News.where(:is_moderated => true).page(params[:page])
  end

  def about
  end
end
