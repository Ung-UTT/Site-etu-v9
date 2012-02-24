module EventsHelper
  def google_agenda_link(event)
    name = CGI::escape(event.name)
    location = CGI::escape(@event.location)
    start_at = l(@event.start_at-2.hour, :format => "%Y%m%dT%H%M%SZ")
    end_at = l(@event.end_at-2.hour, :format => "%Y%m%dT%H%M%SZ")
    description = CGI::escape(@event.description)

    link_to image_tag("others/google_agenda.png"),
      "https://www.google.com/calendar/b/0/render?action=TEMPLATE&text=#{name}&location=#{location}&dates=#{start_at}/#{end_at}&details=#{description}&pli=1&sf=true&output=xml",
      :title => "Ajouter à Google Agenda"
  end

  def mailto_link(event)
    name = CGI::escape(event.name)
    description = CGI::escape(@event.description)
    url = CGI::escape(request.url)
    link_to image_tag("others/mailto.png"),
      "mailto:?Subject=[Evènement UTT] #{name}&body=%0A%0A#{description}%0A%0APlus d'infos: #{url}",
      :title => "Inviter des gens"
  end
end
