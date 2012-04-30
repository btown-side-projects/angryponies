if window.PONIFY_LOADED
  return
window.PONIFY_LOADED = true

# This is the cloudfront endpoint for angryponies.herokuapp.com
HOST = location.hash?.substring(1) || "http://daxq60ud3wnx1.cloudfront.net"

console.log "Angry Ponies: remapping to #{HOST}"

remaps =
  'images/INGAME_BIRDS_ponies.png': /INGAME_BIRDS\.png/
  'images/INGAME_PIGS_chrysalis.png': /INGAME_PIGS\.png/
  'sounds/twilightswear.mp3': /Bird_Red_Flying/
  'sounds/alexsglitch.mp3': /theme\.mp3/
  'flash/CustomVoices.swf': /oices\.swf/
  'images/INGAME_MENU_MAIN_MENU_pony.png': /INGAME_MENU_MAIN_MENU\.png/

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
