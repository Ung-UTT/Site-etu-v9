# encoding: utf-8

class AlbumsController < ApplicationController
  skip_authorization_check

  def index
    authorize! :index, Album
    @albums = Album.all
  end

  def show
    authorize! :read, Album
    @album = Album.find(params[:id])
  end
end
