(function() {
  var HOST, imgs, remapUrl, remaps;

  if (window.PONIFY_LOADED) return;

  window.PONIFY_LOADED = true;

  HOST = "http://angryponies.herokuapp.com";

  console.log("Angry Ponies: remapping to " + HOST);

  remaps = {
    'images/INGAME_BIRDS_ponies.png': /INGAME_BIRDS\.png/,
    'images/INGAME_PIGS_chrysalis.png': /INGAME_PIGS\.png/,
    'sounds/twilightswear.mp3': /Bird_Red_Flying/
  };

  remapUrl = function(url) {
    var newUrl, path, regex;
    for (path in remaps) {
      regex = remaps[path];
      if (regex.test(url)) {
        newUrl = HOST + '/' + path;
        console.log("Remapping " + url + " to " + newUrl);
        return newUrl;
      }
    }
    return url;
  };

  imgs = [];

  window.fetchedUrls = [];

  (function() {
    var laterRemapper;
    laterRemapper = function() {
      var img, newSrc, _i, _len;
      if (imgs.length) {
        for (_i = 0, _len = imgs.length; _i < _len; _i++) {
          img = imgs[_i];
          window.fetchedUrls.push(img.src);
          newSrc = remapUrl(img.src);
          if (img.src !== newSrc) img.src = newSrc;
        }
        return imgs = [];
      }
    };
    return setInterval(laterRemapper, 2);
  })();

  (function() {
    var oldCreateElement;
    oldCreateElement = document.createElement;
    return document.createElement = function(type) {
      var elem;
      elem = oldCreateElement.call(document, type);
      if (type === 'img') imgs.push(elem);
      return elem;
    };
  })();

  (function() {
    var proto;
    proto = XMLHttpRequest.prototype;
    proto.realOpen = proto.open;
    return proto.open = function(method, url, async, user, pass) {
      var newUrl;
      window.fetchedUrls.push(url);
      newUrl = remapUrl(url);
      return this.realOpen(method, newUrl, async, user, pass);
    };
  })();

}).call(this);
