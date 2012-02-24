#TODO: Revoir le stockage des horaires dans la BDD pour quelque chose
#      de plus simple
class Timesheet < ActiveRecord::Base
  validates_presence_of :day, :from, :to, :course

  has_paper_trail

  belongs_to :course

  has_many :timesheets_user, :dependent => :destroy
  has_many :users, :through => :timesheets_user, :uniq => true

  # Jour sous un format lisible 0 -> "Lundi", 1 -> "Mardi", ...
  def t_day
    I18n.t('date.day_names')[day]
  end

  # Heure sous un format lisible
  def t_hour(hour)
    I18n.l Time.at(hour), :format => :hour
  end

  # Semaine sous un format lisible
  def t_week
    (week and !week.empty?) ? "(semaine #{week})" : ''
  end

  # Temps défini par cette horaire
  def range
    "Le #{t_day} de #{t_hour(from)} à #{t_hour(to)} #{t_week}"
  end

  # Est-ce qu'un couple (jour, heure) est compris dans cette horaire
  def during?(daytime, time)
    day == daytime and from <= time and time <= to
  end
end
