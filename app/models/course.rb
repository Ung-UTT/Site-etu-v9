class Course < ActiveRecord::Base
  attr_accessible :name, :description
  validates_presence_of :name

  default_scope order: 'name'

  has_paper_trail

  has_many :annals, dependent: :destroy
  has_many :timesheets, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :documents, as: :documentable, dependent: :destroy
  has_many :users, through: :timesheets, uniq: true

  def schedule
    Timesheet.make_schedule(self.timesheets)
  end

  def to_s
    res = name
    res += " : #{description.truncate(30)}" unless description.blank?
    res
  end
end
