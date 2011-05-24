var keys = [38, 38, 40, 40, 37, 37, 39, 39, 66, 65];
var progress = 0;

$('*').keyup(function(event) {
  if (event.keyCode == 27) {
    $('body').html('<div>Blue Screen Of Death</div>').css('background-color', 'blue');
    $('div').css({'font-size': '8em', 'text-weight': 'bolder', 'text-align': 'center', 'margin-top': '150px'});
  }

  if (event.keyCode == keys[progress]) {
    progress += 1;
    console.log(progress);
    if (progress == keys.length) {
      $('p, li, h1, h2, h3, header').click(function () {
        $(this).fadeOut('slow');
      });
    }
  } else {
    console.log('fail');
    console.log(event.keyCode);
    progress = 0;
  }
});
