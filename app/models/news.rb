class News < ActiveRecord::Base
  paginates_per 5

  accessible(default:   [:title, :content, :event_id],
             moderator: [:is_moderated])

  validates_presence_of :title

  has_paper_trail

  belongs_to :event
  belongs_to :user
  has_many :documents, :as => :documentable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy

  class << self
    def visible
      where(:is_moderated => true).order('updated_at DESC')
    end
  end
end
