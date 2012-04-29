if window.PONIFY_LOADED
  return
window.PONIFY_LOADED = true

HOST = 'http://localhost:5000/'

remaps =
  'images/INGAME_BIRDS_ponies.png': /INGAME_BIRDS\.png/

remapUrl = (url) ->
  # [match, host, rest] = /^http:\/\/([^\/]+)(\/?.*)$/.exec url
  # return HOST + '/assets/' + rest
  for path, regex of remaps
    if regex.test url
      return HOST + path
  return url

imgs = []

do ->
  laterRemapper = ->
    if imgs.length
      for img in imgs
        newSrc = remapUrl(img.src)
        console.log img.src, newSrc
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
    newUrl = remapUrl(url)
    console.log url, newUrl
    return this.realOpen(method, url, async, user, pass)
