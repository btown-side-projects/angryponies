if window.PONIFY_LOADED
  return
window.PONIFY_LOADED = true

HOST = location.hash?.substring(1) || "http://angryponies.herokuapp.com"

console.log "Angry Ponies: remapping to #{HOST}"

remaps =
  'images/INGAME_BIRDS_ponies.png': /INGAME_BIRDS\.png/
  'images/INGAME_PIGS_chrysalis.png': /INGAME_PIGS\.png/
  'sounds/twilightswear.mp3': /Bird_Red_Flying/

remapUrl = (url) ->
  # [match, host, rest] = /^http:\/\/([^\/]+)(\/?.*)$/.exec url
  # return HOST + '/assets/' + rest
  for path, regex of remaps
    if regex.test url
      newUrl = HOST + '/' + path
      console.log "Remapping #{url} to #{newUrl}"
      return newUrl
  return url

imgs = []

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
    return elem

do ->
  proto = XMLHttpRequest.prototype
  proto.realOpen = proto.open
  proto.open = (method, url, async, user, pass) ->
    window.fetchedUrls.push(url)
    newUrl = remapUrl(url)
    # console.log url, newUrl
    return this.realOpen(method, newUrl, async, user, pass)
