class Timesheet < ActiveRecord::Base
  has_paper_trail

  belongs_to :course
  has_and_belongs_to_many :users, :uniq => true

  def range
    from.strftime('Le %A de %#Hh%M à ') + to.strftime('%#Hh%M')
  end

  def during?(time)
    from < time and time < to
  end
end
