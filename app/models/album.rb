# Un album est un événement contenant des images
class Album
  # Sélectionne les événements contenant des images
  def self.all
    Event.all.select {|event| !event.images.empty?}
  end

  # Cherche l'événement avec l'id correspondant
  def self.find(id)
    event = Event.find(id)
    event.images.empty? ? nil : event
  end
end
