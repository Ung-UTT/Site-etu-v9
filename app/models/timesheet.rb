class Timesheet < ActiveRecord::Base
  CATEGORIES = %w(CM TD TP)

  attr_accessible :start_at, :end_at, :week, :category, :room, :course_id
  validates_presence_of :start_at, :end_at, :category, :course
  validates :category, :inclusion => {:in => Timesheet::CATEGORIES}

  has_paper_trail

  belongs_to :course

  has_many :timesheets_user, :dependent => :destroy
  has_many :users, :through => :timesheets_user, :uniq => true

  # Temps défini par cette horaire
  def range
    t_day = I18n.l(start_at, :format => :day)
    t_start_at = I18n.l(start_at, :format => :hour)
    t_end_at = I18n.l(end_at, :format => :hour)
    t_week = (week and !week.empty?) ? " (semaine #{week})" : ''

    "#{short_range} : Le #{t_day} de #{t_start_at} à #{t_end_at}#{t_week}"
  end

  # Description sans les heures
  def short_range
    t_category = category ? "#{category} de " : ''
    t_room = room ? " en #{room}" : ''

    "#{t_category}#{course.name}#{t_room}"
  end

  # Traduit l'horaire en un hash exploitable par FullCalendar
  def to_fullcalendar
    return { 'title' => "#{course.name} #{category}\n#{room}\n#{week}",
             'start_at' => start_at,
             'end_at' => end_at,
             'object' => self,
             'alt' => range,
             'course' => course.name }
  end

  # Selectionne les horaires du semestre actuel
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

  # Fait la répétition des horaires selon le semestre
  def self.make_agenda(array_of_timesheets)
    agenda = []

    # Déjà on selectionne les horaires du semestre
    timesheets = make_schedule(array_of_timesheets)

    # Le semestre actuel est le dernier
    semester = SEMESTERS.last

    # On prend chaque horaire et on le répéte
    timesheets.each do |ts|
      start_at = semester['start_at']
      index = 0 # Nombre de semaines depuis la rentrée

      begin
        day = semester['weeks'][index][ts.start_at.wday, 1] # cf lib/semesters.rb

        if (!ts.week.nil? and ts.week == day) or # Semaine A ou semaine B
           (ts.week.nil? and ['A', 'B'].include?(day)) # Il y a cours ce jour là ?
          hash = ts.to_fullcalendar
          # Comme une répétition, on ajoute les semaines
          hash['start_at'] += index.weeks
          hash['end_at'] += index.weeks
          agenda.push(hash)
        end

        index += 1
      # Tant que l'on est dans le semestre
      end while (start_at + index.weeks) < semester['end_at']
    end

    return agenda
  end
end
