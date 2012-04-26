class Annal < ActiveRecord::Base
  SEMESTERS = %w[A P] # Automne ou Printemps
  TYPES = %w[P M F A] # Partiel, Médian, Final ou Autre

  paginates_per 50

  attr_accessible :course, :semester, :year, :type, :document
  validates_presence_of :course, :semester, :year, :type, :document
  validates_inclusion_of :semester, in: SEMESTERS
  validates_inclusion_of :type, in: TYPES
  validates_uniqueness_of :course_id, scope: [:year, :semester, :type]

  has_paper_trail

  belongs_to :course
  has_one :document, :as => :documentable, :dependent => :destroy

  # On ne garde que les documents qui ne pas vides
  accepts_nested_attributes_for :document, :allow_destroy => true,
    :reject_if => lambda { |d| d[:asset].blank? }
end

