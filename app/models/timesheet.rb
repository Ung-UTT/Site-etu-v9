class Timesheet < ActiveRecord::Base
  validates_presence_of :start_at, :end_at, :course

  has_paper_trail

  belongs_to :course

  has_many :timesheets_user, :dependent => :destroy
  has_many :users, :through => :timesheets_user, :uniq => true

  # Temps défini par cette horaire
  def range
    t_room = room ? " en #{room}" : ''
    t_day = I18n.l(start_at, :format => :day)
    t_start_at = I18n.l(start_at, :format => :hour)
    t_end_at = I18n.l(end_at, :format => :hour)
    t_week = (week and !week.empty?) ? " (semaine #{week})" : ''

    "#{course.name}#{t_room} : Le #{t_day} de #{t_start_at} à #{t_end_at}#{t_week}"
  end

  # Transformat les timesheets pour en faire des objets qui forment
  # un emploi du temps (avec la forme de FullCalendar)
  def self.make_schedule(array_of_timesheets)
    timesheets = array_of_timesheets.flatten.uniq

    # Le semestre actuel est le dernier
    semester = SEMESTERS.last
    # On sélectionne les horaires de ce semestre
    timesheets = timesheets.select do |ts|
      ts.start_at >= semester['start_at'] && ts.start_at <= semester['end_at']
    end

    return timesheets
  end
end
