(function() {
  var AB_HOST, HOST, HOST_IS_URL, JS_HOST, imgs, is_chrome, loadElem, newLocation, objs, reloadWindow, remapUrl, remaps, _ref;

  if (window.PONIFY_LOADED) return;

  window.PONIFY_LOADED = true;

  
  (function(d,c){var a,b,g,e;a=d.createElement("script");a.type="text/javascript";
  a.async=!0;a.src=("https:"===d.location.protocol?"https:":"http:")+
  '//api.mixpanel.com/site_media/js/api/mixpanel.2.js';b=d.getElementsByTagName("script")[0];
  b.parentNode.insertBefore(a,b);c._i=[];c.init=function(a,d,f){var b=c;
  "undefined"!==typeof f?b=c[f]=[]:f="mixpanel";g=['disable','track','track_pageview',
  'track_links','track_forms','register','register_once','unregister','identify',
  'name_tag','set_config'];
  for(e=0;e<g.length;e++)(function(a){b[a]=function(){b.push([a].concat(
  Array.prototype.slice.call(arguments,0)))}})(g[e]);c._i.push([a,d,f])};window.mixpanel=c}
  )(document,[]);
  mixpanel.init("1b8facd51b0e1f8587251d8a7825f935", {debug: true});;

  HOST = JS_HOST = (_ref = window.top.location.hash) != null ? _ref.substring(1) : void 0;

  HOST_IS_URL = /http:\/\/[\w\.]+/.test(HOST);

  if (!HOST_IS_URL) {
    HOST = "http://daxq60ud3wnx1.cloudfront.net";
    JS_HOST = "http://angryponies.herokuapp.com";
  }

  AB_HOST = 'chrome.angrybirds.com';

  if (document.domain !== AB_HOST) {
    if (confirm("Redirecting to " + AB_HOST + "! Don't forget to click the bookmarklet again once you get there!")) {
      newLocation = "http://" + AB_HOST + "/" + (HOST_IS_URL ? '#' + HOST : '');
      mixpanel.track("ponify_redirect", {
        ponify_target_location: newLocation,
        ponify_start_location: window.location.toString()
      });
      window.location = newLocation;
    }
    return;
  }

  
  window.requestAnimFrame = (function(){
    return window.requestAnimationFrame    || 
      window.webkitRequestAnimationFrame || 
      window.mozRequestAnimationFrame  || 
      window.oRequestAnimationFrame   || 
      window.msRequestAnimationFrame   || 
      function(/* function */ callback, /* DOMElement */ element){
        return window.setTimeout(callback, 1000 / 60);
      };
  })();
  window.cancelRequestAnimFrame = ( function() {
    return window.cancelAnimationFrame     ||
      window.webkitCancelRequestAnimationFrame  ||
      window.mozCancelRequestAnimationFrame    ||
      window.oCancelRequestAnimationFrame   ||
      window.msCancelRequestAnimationFrame    ||
      clearTimeout
  } )();
;

  reloadWindow = function() {
    var STYLE, clearTimeouts, ifrm, rq, scriptSrc, text, win;
    mixpanel.track("ponify_reload");
    document.head.innerHTML = "";
    STYLE = "border: 0; position:absolute; top:0; left:0; right:0; bottom:0; width:100%; height:100%";
    document.body.innerHTML = "<iframe id='ponified' src='about:blank' style='" + STYLE + "' />";
    (clearTimeouts = function() {
      var arg, clearer, creator, next, timeoutFuncPairs, _i, _len, _ref2, _results;
      timeoutFuncPairs = [['setTimeout', 'clearTimeout', 1000], ['setInterval', 'clearInterval', 1000], ['requestAnimFrame', 'cancelRequestAnimFrame', document]];
      _results = [];
      for (_i = 0, _len = timeoutFuncPairs.length; _i < _len; _i++) {
        _ref2 = timeoutFuncPairs[_i], creator = _ref2[0], clearer = _ref2[1], arg = _ref2[2];
        next = window[creator]((function() {
          return 0;
        }), arg);
        console.log("Removing " + creator + " below " + next);
        _results.push((function() {
          var _results2;
          _results2 = [];
          while (next >= 0) {
            window[clearer](next);
            _results2.push(next -= 1);
          }
          return _results2;
        })());
      }
      return _results;
    })();
    ifrm = document.getElementById('ponified');
    win = (ifrm.contentWindow) ? ifrm.contentWindow : (ifrm.contentDocument.document) ? ifrm.contentDocument.document : ifrm.contentDocument;
    scriptSrc = JS_HOST + '/ponify.js';
    rq = new XMLHttpRequest;
    rq.open('get', '', false);
    rq.send();
    text = rq.responseText.replace('<head', '<script src=' + scriptSrc + '></script><head');
    text = text.replace('src="/images/loading_image_bird.png"', 'src="' + HOST + '/images/loading_image_bird.png"');
    win.document.open();
    win.document.write(text);
    return win.document.close();
  };

  if (document.body) {
    is_chrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1;
    if (is_chrome) {
      reloadWindow();
    } else {
      loadElem = document.createElement('h1');
      loadElem.setAttribute("style", "position:fixed; top:0; left:0;");
      loadElem.innerHTML = "Loading Angry Ponies, please wait...";
      document.body.appendChild(loadElem, document.body.firstChild);
      setTimeout(reloadWindow, 5000);
    }
    return;
  }

  console.log("Angry Ponies: remapping to " + HOST);

  mixpanel.track('ponify', {
    ponify_host: HOST
  });

  remaps = {
    'images/mane6.png': /INGAME_BIRDS\.png/,
    'images/mane6.json': /INGAME_BIRDS\.json/,
    'images/INGAME_PIGS_chrysalis.png': /INGAME_PIGS\.png/,
    'sounds/twilightswear.mp3': /Bird_Red_Flying/,
    'sounds/alexsglitch.mp3': /theme\.mp3/,
    'flash/CustomVoices.swf': /oices\.swf/,
    'images/INGAME_MENU_MAIN_MENU_pony.png': /INGAME_MENU_MAIN_MENU\.png/,
    'images/INGAME_MENU_LEVEL_SELECTION_pony.png': /INGAME_MENU_LEVEL_SELECTION\.png/,
    'images/INGAME_MENU_LEVELEND_pony.png': /INGAME_MENU_LEVELEND\.png/,
    'images/INGAME_MENU_EPISODE_SELECTION.png': /INGAME_MENU_EPISODE_SELECTION.png/,
    'images/splash.jpg': /Splash_AB_Logo/
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

  window.remapSound = remapUrl;

  imgs = [];

  objs = [];

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
      var access, elem;
      elem = oldCreateElement.call(document, type);
      if (type === 'img') imgs.push(elem);
      if (type === 'object') {
        access = document.createElement('param');
        access.setAttribute('name', 'allowScriptAccess');
        access.setAttribute('value', 'always');
        elem.appendChild(access);
        elem.oldSetAttribute = elem.setAttribute;
        elem.setAttribute = function(key, value) {
          if (key === 'data') value = remapUrl(value);
          return elem.oldSetAttribute(key, value);
        };
      }
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

  (function() {
    var adRemover;
    adRemover = function() {
      var ad, adId, _i, _len, _ref2, _results;
      _ref2 = ['right-banner', 'left-banner'];
      _results = [];
      for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
        adId = _ref2[_i];
        ad = document.getElementById(adId);
        if (ad) {
          _results.push(ad.setAttribute('style', 'visiblity:hidden; display:none;'));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };
    return setInterval(adRemover, 1000);
  })();

}).call(this);
