xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title t('helpers.rss_classifieds')
    xml.link url_for(controller: 'classified', format: 'rss', only_path: false)

    for classified in @classifieds
      xml.item do
        xml.title classified.title
        xml.description classified.description
        xml.pubDate classified.created_at.to_s(:rfc822)
        xml.link classified_url(classified)
        xml.guid classified_url(classified)
      end
    end
  end
end
