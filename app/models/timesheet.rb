class Timesheet < ActiveRecord::Base
  validates_presence_of :start_at, :end_at, :course

  has_paper_trail

  belongs_to :course

  has_many :timesheets_user, :dependent => :destroy
  has_many :users, :through => :timesheets_user, :uniq => true

  # Mixe les timesheets pour en faire un emploi du temps
  def self.make_schedule(array_of_timesheets)
    timesheets = array_of_timesheets.flatten.uniq
    # Horaires pour chaque jour (lundi, mardi, ..., samedi)
    res = [[],[],[],[],[],[]]
    timesheets.each do |t|
      # .wday est l'index du jour de la semaine (0 pour dimanche, ...)
      res[t.start_at.wday-1].push(t) # On ajoute l'horaire
    end
    res
  end

  # Temps défini par cette horaire
  def range
    t_room = room ? " en #{room}" : ''
    t_day = I18n.l(start_at, :format => :day)
    t_start_at = I18n.l(start_at, :format => :hour)
    t_end_at = I18n.l(end_at, :format => :hour)
    t_week = (week and !week.empty?) ? " (semaine #{week})" : ''

    "#{course.name}#{t_room} : Le #{t_day} de #{t_start_at} à #{t_end_at}#{t_week}"
  end
end
