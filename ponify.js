(function() {
  var HOST, imgs, remapUrl, remaps;

  if (window.PONIFY_LOADED) return;

  window.PONIFY_LOADED = true;

  HOST = 'http://localhost:5000/';

  remaps = {
    'images/INGAME_BIRDS_ponies.png': /INGAME_BIRDS\.png/
  };

  remapUrl = function(url) {
    var path, regex;
    for (path in remaps) {
      regex = remaps[path];
      if (regex.test(url)) return HOST + path;
    }
    return url;
  };

  imgs = [];

  (function() {
    var laterRemapper;
    laterRemapper = function() {
      var img, newSrc, _i, _len;
      if (imgs.length) {
        for (_i = 0, _len = imgs.length; _i < _len; _i++) {
          img = imgs[_i];
          newSrc = remapUrl(img.src);
          console.log(img.src, newSrc);
          img.src = newSrc;
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
      newUrl = remapUrl(url);
      console.log(url, newUrl);
      return this.realOpen(method, url, async, user, pass);
    };
  })();

}).call(this);
