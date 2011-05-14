class HomeController < ApplicationController
  skip_authorization_check

  def index
    @news = News.paginate :page => params[:page], :order => 'created_at DESC'
    if connected?
      @weather = YahooWeather::Client.new.lookup_by_woeid(629484, 'c')
    end
  end

  # TODO: Nom en anglais ?
  def journal
    @news = News.paginate(:page => params[:page], :order => 'created_at DESC').select { |n| n.title.match('Journal') }
  end
end
