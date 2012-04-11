#!/usr/bin/env ruby

# Importe les emplois du temps (précédement convertis) vers la base de
# données :

# ATTENTION : Necessite d'avoir déjà importer les utilisateurs et
#             d'avoir les emploi du temps convertis.

require File.expand_path("../../config/environment", __FILE__)

DB_FILE = 'data/schedule.marshal'

# Attributs dans le fichier convertit :
#   "weekname" : T, A, B
#   "week" : 1, 2 : toutes les semaines, ou 1 semaine sur 2 # FIXME : utile ?
#   "room" : C101, A002, ...
#   "students" : ['mariedor', 'thevenin', ...]
#   "uv" : MTX2, LE08
#   "type" : TD, CM, TP
#   "day" : 0..6 (lundi..samedi)
#   "start" : [8, 0], ...
#   "end" : [19, 30], ...

if File.exists?(DB_FILE)
  puts "Use #{BD_FILE.to_s}"
  timesheets = Marshal.load(File.read(DB_FILE))
else
  puts "You must cconvert schedules first"
  exit
end

timesheets.each do |ts|
  # Créer l'horaire
  timesheet = Timesheet.create(
    # Date du premier cours (on sait pas donc première semaine de rentrée
    :start_at => SEMESTERS.last['start_at'] + ts['day'].days +
                 ts['start'][0].hours + ts['start'][1].minutes,
    :end_at => SEMESTERS.last['start_at'] + ts['day'].days +
               ts['end'][0].hours + ts['end'][1].minutes,
    # Semaine A, semaine B ou rien
    :week => ts['weekname'] == 'T' ? nil : ts['weekname'],
    :room => ts['room'], # Salle
    :category => ts['type'], # CM, TD, TP
    # Crée le cours s'il n'existe pas
    :course => Cours.find_or_create_by_name(ts['uv']),
  )

  # Trouver les étudiants
  users = User.all.select? {|user| ts['students'].include?(user.login)}

  if users.nil? or users.empty?
    puts "You must import users first"
  else
    # Ajouter l'horaire aux étudiants
    users.each do |user|
      user.timesheets << timesheet
    end
  end
end
