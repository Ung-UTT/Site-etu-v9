class HomeController < ApplicationController
  skip_authorization_check

  def index
    @news = News.descending
    if connected?
      @weather = YahooWeather::Client.new.lookup_by_woeid(629484, 'c')
    end
  end

  # TODO: Nom en anglais ?
  def journal
    # TODO: Créé par l'association N'UTT ? Par le président du N'UTT ? Contient N'UTT/Journal ?
    @news = News.descending.select { |n| n.title.match('Journal') }
  end
end
