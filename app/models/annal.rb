class Annal < ActiveRecord::Base
  SEMESTERS = %w[A P] # Automne ou Printemps
  KINDS = %w[P M F A] # Partiel, Médian, Final ou Autre

  paginates_per 50

  attr_accessible :course_id, :semester, :year, :kind, :documents_attributes
  validates_presence_of :course_id, :semester, :year, :kind, :documents
  validates_inclusion_of :semester, in: SEMESTERS
  validates_inclusion_of :kind, in: KINDS
  validates_uniqueness_of :course_id, scope: [:year, :semester, :kind]

  default_scope order: 'year DESC'

  has_paper_trail

  belongs_to :course
  has_many :documents, as: :documentable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  # On ne garde que les documents qui ne pas vides
  accepts_nested_attributes_for :documents, allow_destroy: true, reject_if: :all_blank

  def readable_kind
    I18n.t("model.annal.kinds.#{kind}")
  end

  def readable_semester
    I18n.t("model.annal.semesters.#{semester}")
  end

  def to_s
    "#{course.name} #{readable_kind} #{readable_semester} #{year}"
  end
end
