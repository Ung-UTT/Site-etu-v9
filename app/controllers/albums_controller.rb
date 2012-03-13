# encoding: utf-8

class AlbumsController < ApplicationController
  # On n'utilise pas CanCan directement les objets Albums sont des évènements
  skip_authorization_check

  def index
    authorize! :index, Album # On autorise à la main
    @albums = Album.all
  end

  def show
    authorize! :read, Album # On autorise à la main
    @album = Album.find(params[:id])
  end
end
