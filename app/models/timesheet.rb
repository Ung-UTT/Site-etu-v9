class Timesheet < ActiveRecord::Base
  has_paper_trail

  belongs_to :course

  has_many :timesheets_user, :dependent => :destroy
  has_many :users, :through => :timesheets_user, :uniq => true

  def t_day
    I18n.t('date.day_names')[day]
  end

  def t_hour(hour)
    I18n.l Time.at(hour), :format => :hour
  end

  def t_week
    (week and !week.empty?) ? "(semaine #{week})" : ''
  end

  def range
    "Le #{t_day} de #{t_hour(from)} à #{t_hour(to)} #{t_week}"
  end

  def during?(daytime, time)
    day == daytime and from < time and time < to
  end
end
