xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title t('helpers.rss_news')
    xml.link url_for(controller: 'news', format: 'rss', only_path: false)

    for news in @news
      xml.item do
        xml.title news.title
        xml.description news.content
        xml.pubDate news.created_at.to_s(:rfc822)
        xml.link news_url(news)
        xml.guid news_url(news)
      end
    end
  end
end
