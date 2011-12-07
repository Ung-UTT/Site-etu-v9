# Un album est un événement contenant des photos
class Album
  def self.all
    Event.all.map { |e| event_to_album(e) }.compact
  end

  def self.find(id)
    e = Event.find(id)
    event_to_album(e)
  end

  def self.event_to_album(event)
    images = event.documents.select(&:image?)
    if images.empty?
      nil
    else
      {:event => event, :images => event.documents.select(&:image?)}
    end
  end
end
