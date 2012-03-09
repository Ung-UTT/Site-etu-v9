//= require jquery
//= require rails
//= require chosen

$(function () {
  $('select.chosen').chosen();

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
