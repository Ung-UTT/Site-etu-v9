# Un album est un événement contenant des images
class Album
  def self.all
    Event.all.select {|event| !event.images.empty?}
  end

  def self.find(id)
    event = Event.find(id)
    if event.images.empty?
      nil
    else
      event
    end
  end
end
