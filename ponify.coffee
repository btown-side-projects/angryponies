# This is the cloudfront endpoint for angryponies.herokuapp.com
HOST = JS_HOST = window.top.location.hash?.substring(1)
HOST_IS_URL = /http:\/\/[\w\.]+/.test(HOST)
if not HOST_IS_URL
  HOST = "http://daxq60ud3wnx1.cloudfront.net"
  JS_HOST = "http://angryponies.herokuapp.com"

AB_HOST = 'chrome.angrybirds.com'

if document.domain != AB_HOST
  if confirm "Redirecting to #{AB_HOST}! Don't forget to click the bookmarklet again once you get there!"
    window.location = "http://#{AB_HOST}/#{if HOST_IS_URL then '#'+HOST else ''}"
  return

if window.PONIFY_LOADED
  return
window.PONIFY_LOADED = true

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

if document.body
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
  scriptSrc = JS_HOST + '/ponify.js'
  rq = new XMLHttpRequest
  rq.open('get', '', false)
  rq.send()
  text = rq.responseText.replace('<head', '<script src=' + scriptSrc + '></script><head')
  win.document.open()
  win.document.write(text)
  win.document.close()
  return

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
  mixpanel.init("1b8facd51b0e1f8587251d8a7825f935");
  mixpanel.track("ponify", {ponify_host: HOST})`

console.log "Angry Ponies: remapping to #{HOST}"

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
  'images/INGAME_MENU_LEVELEND_pony.png': /INGAME_MENU_LEVELEND\.png/
  'images/splash.jpg': /Splash_AB_Logo/

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
    # if objs.length
    #   for obj in objs
    #     window.fetchedUrls.push(obj)
    #     newData = remapUrl(obj.getAttribute('data'))
    #     obj.setAttribute('data', newData)
    #   objs = []
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

# do ->
#   gwtVoiceId = 'gwtVoices1000'
#   gwtVoices = null
#   movie = null
#   loaded = false
#   voicesFinder = ->
#     return if loaded
#     if gwtVoices
#       if not gwtVoices.createSound # not yet loaded
#         gwtVoices.setAttribute 'data', HOST + '/flash/CustomVoices.swf'
#         loaded = true
#     else
#       gwtVoices = document.getElementById gwtVoiceId
#       movie = document.VoicesMovie
#   setInterval voicesFinder, 10

do ->
  proto = XMLHttpRequest.prototype
  proto.realOpen = proto.open
  proto.open = (method, url, async, user, pass) ->
    window.fetchedUrls.push(url)
    newUrl = remapUrl(url)
    # console.log url, newUrl
    return this.realOpen(method, newUrl, async, user, pass)
