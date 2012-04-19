class Annal < ActiveRecord::Base
  paginates_per 50

  attr_accessible :name, :description, :date
  validates_presence_of :name

  has_paper_trail

  belongs_to :course
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :documents, :as => :documentable, :dependent => :destroy

  # Dans un formulaire d'une annale, on peut ajouter des documents
  # On ne garde que les documents qui ne pas vides
  accepts_nested_attributes_for :documents, :allow_destroy => true,
    :reject_if => lambda { |d| d[:asset].blank? }
end
