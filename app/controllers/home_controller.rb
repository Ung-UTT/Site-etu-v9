class HomeController < ApplicationController
  skip_authorization_check

  def index
    @news = News.page(params[:page])
    #if connected?
    #  @weather = YahooWeather::Client.new.lookup_by_woeid(629484, 'c')
    #end
  end

  def newspaper
    # TODO: News associées à l'association N'UTT
    @news = News.page(params[:page]).select { |n| n.title.match('Journal') }
  end
end
