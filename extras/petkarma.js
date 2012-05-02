(function() {
  var NPETS = 3, MAXLEN = 100, INTERVAL = 100,
    POS_PROP = 'background-position', KARMA_POS = '-0px -0px', DIS_POS = '-55px -0px',
    $name = $('span.redditname a'), $img = $('#header-img'),
    initialName = $name.text(), initialAttrib = $img.parent().attr('title');
  $name.text('pet me please');
  $img.css(POS_PROP,DIS_POS);
  $img.parent().removeAttr('title');
  $img.mouseenter(function() {
    var buf = [];
    window.petkarmaint = setInterval(function() {
      var nmin = 0, nmax = 0, i = 1, indownstroke = true, happy;
      buf.push(window.petkarmay);
      while (i < buf.length - 1) {
        if (buf[i-1] > buf[i] && buf[i+1] >= buf[i]) {
          nmin += 1;
          indownstroke = true;
        };
        if (buf[i-1] < buf[i] && buf[i+1] <= buf[i]) {
          nmax += 1;
          indownstroke = false;
        };
        i += 1;
      };
      if (nmin >= NPETS - 1) {
        window.petkarmahappy = true;
        $name.text('HAPPY! coded by btown_brony, vectors by Pinkie_Pi');
        $img.css(POS_PROP,KARMA_POS);
      };
      if (nmin < NPETS - 1) {
        window.petkarmahappy = false;
        $name.text(indownstroke ? 'pet' : '...');
        $img.css(POS_PROP,DIS_POS);
      };
    }, INTERVAL);
  }).mousemove(function(e) {
    window.petkarmay = e.pageY;
  }).mouseleave(function() {
    if (window.petkarmaint) {
      clearInterval(window.petkarmaint);
      window.petkarmaint = undefined;
      /* $name.text(initialName); */
      /* leave her smiling or not smiling */
    };
    if (!window.petkarmahappy) {
      $name.text('you gave up...');
    };
  });
})();