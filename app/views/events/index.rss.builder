xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title t('helpers.rss_events')
    xml.link url_for(controller: 'events', format: 'rss', only_path: false)

    for event in @events
      xml.item do
        xml.title event.title
        xml.description event.description
        xml.pubDate event.created_at.to_s(:rfc822)
        xml.link event_url(event)
        xml.guid event_url(event)
      end
    end
  end
end
