xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title t('helpers.rss_activity')
    xml.link url_for(controller: 'activities', action: 'show', format: 'rss', only_path: false)

    @activities.each do |activity|
      xml.item do
        xml.title strip_tags(activity.event)
        xml.description activity.event
        xml.pubDate activity.when
        xml.link activity.link
      end
    end
  end
end
