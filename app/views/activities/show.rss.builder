xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title t('helpers.rss_activity')
    xml.link url_for(controller: 'activities', action: 'show', format: 'rss', only_path: false)

    @activities.each do |activity|
      xml.item do
        xml.title "#{activity.user} #{t("activities.actions.#{activity.what}")} #{activity.resource}"
        xml.description "#{link_to_user(activity.user)} #{t("activities.actions.#{activity.what}")} #{link_to(activity.resource, activity.resource)}."
        xml.pubDate activity.when
        xml.link link_to(activity.resource, activity.resource)
      end
    end
  end
end
