//= require jquery
//= require rails

var keys = [38, 38, 40, 40, 37, 39, 37, 39, 66, 65];
var progress = 0;

$('body').keyup(function(event) {
  if (event.keyCode == 27) {
    $('body').html('<div>Blue Screen Of Death</div>').css({'background-color': 'blue', 'background-image': 'url()'}).remove;
    $('div').css({'font-size': '8em', 'text-weight': 'bolder', 'text-align': 'center', 'margin-top': '150px'});
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
