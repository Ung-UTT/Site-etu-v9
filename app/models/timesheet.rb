class Timesheet < ActiveRecord::Base
  has_paper_trail

  belongs_to :course
  has_and_belongs_to_many :users, :uniq => true

  def range
    start.strftime('Le %A de %#Hh%M à ') + self.end.strftime('%#Hh%M')
  end
end
