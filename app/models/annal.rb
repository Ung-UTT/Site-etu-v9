class Annal < ActiveRecord::Base
  SEMESTERS = %w[A P] # Automne ou Printemps
  KINDS = %w[P M F A] # Partiel, Médian, Final ou Autre

  paginates_per 50

  attr_accessible :course_id, :semester, :year, :kind, :documents_attributes
  validates_presence_of :course_id, :semester, :year, :kind, :documents
  validates_inclusion_of :semester, in: SEMESTERS
  validates_inclusion_of :kind, in: KINDS
  validates_uniqueness_of :course_id, scope: [:year, :semester, :kind]

  has_paper_trail

  belongs_to :course
  has_many :documents, :as => :documentable, :dependent => :destroy

  # On ne garde que les documents qui ne pas vides
  accepts_nested_attributes_for :documents, :allow_destroy => true,
    :reject_if => lambda { |d| d[:asset].blank? }

  def to_s
    "#{course.name} #{semester}#{year} #{I18n.t("model.annal.kinds.#{kind}")}"
  end
end

