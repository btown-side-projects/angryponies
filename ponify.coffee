if window.PONIFY_LOADED
  return
window.PONIFY_LOADED = true

# Mixpanel integration
`
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
  mixpanel.init("1b8facd51b0e1f8587251d8a7825f935", {debug: true});`

HOST = JS_HOST = window.top.location.hash?.substring(1)
HOST_IS_URL = /http:\/\/[\w\.]+/.test(HOST)
if not HOST_IS_URL
  # This is the cloudfront endpoint for angryponies.herokuapp.com
  HOST = "http://daxq60ud3wnx1.cloudfront.net"
  JS_HOST = "http://angryponies.herokuapp.com"

AB_HOST = 'chrome.angrybirds.com'

if document.domain != AB_HOST
  if confirm "Redirecting to #{AB_HOST}! Don't forget to click the bookmarklet again once you get there!"
    newLocation = "http://#{AB_HOST}/#{if HOST_IS_URL then '#'+HOST else ''}"
    mixpanel.track("ponify_redirect", {ponify_target_location: newLocation, ponify_start_location: window.location.toString()})
    window.location = newLocation
  return

# Setting up requestAnimationFrame stuff
`
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
`

reloadWindow = ->
  mixpanel.track("ponify_reload")
  # Ponify is being called too late to inject code,
  # so "refresh" the page using an iframe
  document.head.innerHTML=""
  STYLE = "border: 0; position:absolute; top:0; left:0; right:0; bottom:0; width:100%; height:100%"
  document.body.innerHTML="<iframe id='ponified' src='about:blank' style='#{STYLE}' />"
  do clearTimeouts = ->
    timeoutFuncPairs = [
      ['setTimeout', 'clearTimeout', 1000],
      ['setInterval', 'clearInterval', 1000],
      ['requestAnimFrame', 'cancelRequestAnimFrame', document],
    ]
    for [creator, clearer, arg] in timeoutFuncPairs
      next = window[creator]((-> 0), arg)
      console.log "Removing #{creator} below #{next}"
      while next >= 0
        window[clearer](next)
        next -= 1
  ifrm = document.getElementById('ponified')
  win = `(ifrm.contentWindow) ? ifrm.contentWindow : (ifrm.contentDocument.document) ? ifrm.contentDocument.document : ifrm.contentDocument`
  scriptSrc = JS_HOST + '/ponify.js?' + Math.random()
  rq = new XMLHttpRequest
  rq.open('get', '', false)
  rq.send()
  text = rq.responseText.replace('<head', '<script src=' + scriptSrc + '></script><head')
  text = text.replace('src="/images/loading_image_bird.png"', 'src="' + HOST + '/images/loading_image_bird.png"')
  # console.log text
  win.document.open()
  win.document.write(text)
  win.document.close()

if document.body
  is_chrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1
  if is_chrome
    reloadWindow()
  else
    # On firefox, and possibly other browsers, if the window is reloaded too quickly,
    # there is a strange "o.body is null" bug. Wait for a few seconds to avoid this more often.
    loadElem = document.createElement 'h1'
    loadElem.setAttribute "style", "position:fixed; top:0; left:0;"
    loadElem.innerHTML = "Loading Angry Ponies, please wait..."
    document.body.appendChild(loadElem, document.body.firstChild)
    setTimeout reloadWindow, 5000
  return

console.log "Angry Ponies: remapping to #{HOST}"
mixpanel.track('ponify', {ponify_host: HOST})

remaps =
  # 'images/INGAME_BIRDS_ponies.png': /INGAME_BIRDS\.png/
  'images/mane6.png': /INGAME_BIRDS\.png/
  'images/mane6.json': /INGAME_BIRDS\.json/
  'images/INGAME_PIGS_chrysalis.png': /INGAME_PIGS\.png/
  'sounds/twilightswear.mp3': /Bird_Red_Flying/
  # 'sounds/twilightmore.mp3': /Bird_Red_Slingshot/
  # 'sounds/twilightverysmart.mp3': /Bird_Red_Selected/
  # 'sounds/twilighthigirls.mp3': /Bird_Red_Flying/
  # 'sounds/twilightaah.mp3': /Bird_Red_(Collision)|(Damage)/
  'sounds/alexsglitch.mp3': /theme\.mp3/
  'flash/CustomVoices.swf': /oices\.swf/
  'images/INGAME_MENU_MAIN_MENU_pony.png': /INGAME_MENU_MAIN_MENU\.png/
  'images/INGAME_MENU_LEVEL_SELECTION_pony.png': /INGAME_MENU_LEVEL_SELECTION\.png/,
  'images/INGAME_MENU_LEVELEND_pony.png': /INGAME_MENU_LEVELEND\.png/
  'images/INGAME_MENU_EPISODE_SELECTION.png': /INGAME_MENU_EPISODE_SELECTION.png/
  'images/splash.jpg': /Splash_AB_Logo/
  # 'images/loading_image_bird.png': /Splash_Rovio_Logo.png/

remapUrl = (url) ->
  # [match, host, rest] = /^http:\/\/([^\/]+)(\/?.*)$/.exec url
  # return HOST + '/assets/' + rest
  for path, regex of remaps
    if regex.test url
      newUrl = HOST + '/' + path
      console.log "Remapping #{url} to #{newUrl}"
      return newUrl
  return url

window.remapSound = remapUrl

imgs = []
objs = []
window.fetchedUrls = []

do ->
  laterRemapper = ->
    if imgs.length
      for img in imgs
        window.fetchedUrls.push(img.src)
        newSrc = remapUrl(img.src)
        if img.src != newSrc
          img.src = newSrc
      imgs = []
  setInterval laterRemapper, 2

do ->
  oldCreateElement = document.createElement
  document.createElement = (type) ->
    elem = oldCreateElement.call document, type
    if type == 'img'
      imgs.push elem
    if type == 'object'
      access = document.createElement('param')
      access.setAttribute 'name', 'allowScriptAccess'
      access.setAttribute 'value', 'always'
      elem.appendChild access
      elem.oldSetAttribute = elem.setAttribute
      elem.setAttribute = (key, value) ->
        if key == 'data' then value = remapUrl(value)
        elem.oldSetAttribute(key, value)
    # TODO: handle type == 'param' and ensure overriding allowScriptAccess
    return elem

do ->
  proto = XMLHttpRequest.prototype
  proto.realOpen = proto.open
  proto.open = (method, url, async, user, pass) ->
    window.fetchedUrls.push(url)
    newUrl = remapUrl(url)
    # console.log url, newUrl
    return this.realOpen(method, newUrl, async, user, pass)

# Remove ads, because we can...
do ->
  adRemover = ->
    for adId in ['right-banner','left-banner']
      ad = document.getElementById(adId)
      # if ad then ad.parentNode.removeChild(ad)
      if ad then ad.setAttribute('style', 'visiblity:hidden; display:none;');
  setInterval adRemover, 1000
