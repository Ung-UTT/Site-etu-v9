class HomeController < ApplicationController
  skip_authorization_check

  def index
    @news = News.order('created_at desc')
    if connected?
      @weather = YahooWeather::Client.new.lookup_by_woeid(629484, 'c')
    end
  end
end
