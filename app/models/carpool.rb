class Carpool < ActiveRecord::Base
  attr_accessible :description, :departure, :arrival, :date, :is_driver
  validates_presence_of :description, :departure, :arrival, :date, :user

  has_paper_trail

  belongs_to :user
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :documents, :as => :documentable, :dependent => :destroy

  def to_s
    "#{departure} - #{arrival}"
  end
end
