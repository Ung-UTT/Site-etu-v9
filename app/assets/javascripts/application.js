//= require jquery
//= require rails
//= require chosen
//= require fullcalendar
//= require markitup
//= require markdown

$(function () {
  // Éditeur WYSIWYM pour formater des textes avec le markdown
  $("textarea.rich-content").markItUp(mySettings);

  // Selecteurs et selecteurs multiples
  // Permet de rechercher dans un grande liste
  $('select.chosen').chosen();

  // Pour pas charger ça tout le temps :
  // (événements définis dans _schedule.html.erb)
  if (typeof(fullcalendar_schedule) != 'undefined') {
    // Emploi du temps (horaires, vue semaine)
    $('.schedule').fullCalendar({
      header: { left: '', center: '', right:  ''}, // Pas de header
      height: 800,
      minTime: 8, // On ne va pas en dessous de 8h
      maxTime: 20, // On ne va pas à plus de 20h
      columnFormat: {
        month: 'dddd', // Monday
        week: 'dddd', // Monday
        day: 'dddd'  // Monday
      },
      events: fullcalendar_schedule,
      // Débute le jour de la rentrée
      year: fullcalendar_schedule_start['year'],
      month: fullcalendar_schedule_start['month'],
      date: fullcalendar_schedule_start['day'],
      // Traductions
      monthNames: fullcalendar_schedule_dates['monthNames'],
      monthNamesShort: fullcalendar_schedule_dates['monthNamesShort'],
      dayNames: fullcalendar_schedule_dates['dayNames'],
      dayNamesShort: fullcalendar_schedule_dates['dayNamesShort'],
    });
  }

  // Agenda complet
  // (événements définis dans _agenda.html.erb)
  if (typeof(fullcalendar_agenda) != 'undefined') {
    // Emploi du temps (horaires, vue semaine)
    $('.agenda').fullCalendar({
      columnFormat: {
        month: 'dddd', // Monday
        week: 'dddd d', // Monday 19
        day: 'dddd d'  // Monday 19
      },
      events: fullcalendar_agenda,
      // Traductions
      monthNames: fullcalendar_agenda_dates['monthNames'],
      monthNamesShort: fullcalendar_agenda_dates['monthNamesShort'],
      dayNames: fullcalendar_agenda_dates['dayNames'],
      dayNamesShort: fullcalendar_agenda_dates['dayNamesShort'],
    });
  }


  // Code Konami (suppprime éléments quand on clique dessus
  // et "Echap" : met un BSOD
  var keys = [38, 38, 40, 40, 37, 39, 37, 39, 66, 65];
  var progress = 0;

  $('body').keyup(function(event) {
    if (event.keyCode == 27) {
      $('body').html('Blue Screen Of Death').css({'background-color': 'blue',
        'background-image': 'url()', 'font-size': '8em', 'text-weight': 'bolder',
        'text-align': 'center', 'margin-top': '150px', 'box-shadow': 'none'});
    }

    if (event.keyCode == keys[progress]) {
      progress += 1;
      console.log(progress);
      console.log(event.keyCode);
      if (progress == keys.length) {
        $('a, p, li, h1, h2, h3, header').click(function () {
          $(this).fadeOut('slow');
          return false;
        });
      }
    } else {
      progress = 0;
    }
  });
});
