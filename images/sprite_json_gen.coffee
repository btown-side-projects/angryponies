fs = require 'fs'
_ = require 'underscore'

box2sprites = (box, spriteNames) ->
  [x,y,w,h] = box
  return ({id:spriteName, x:x, y:y, width:w, height:h, pivotx:w/2, pivoty:h/2} for spriteName in spriteNames)

sprites2obj = (sprites, image) ->
  obj = {image: image}
  obj.spriteCount = sprites.length
  obj["sprite_#{i}"] = sprite for sprite, i in sprites
  return obj

do mane6birds = ->
  boxes =
    twilight: [221,10,71,63]
    rarity: [124,6,92,59]
    fs: [10,2,106,61]
    pinkie: [25,80,95,65]
    aj: [136,96,40,32]
    rd: [200,71,85,70]

  basicSufs = ['1','2','BLINK','FLYING','FLYING_YELL','YELL']
  allSufs = basicSufs.concat ['SPECIAL','SPECIAL_2','SPECIAL_3']
  spriteNames =
    pinkie: ("BIRD_BLACK_#{suf}" for suf in allSufs)
    aj: ("BIRD_BLUE_#{suf}" for suf in allSufs)
    twilight: _.flatten ("BIRD_#{type}_#{suf}" for suf in allSufs for type in ['RED','REDBIG'])
    rarity: ("BIRD_WHITE_#{suf}" for suf in allSufs)
    rd: ("BIRD_YELLOW_#{suf}" for suf in allSufs)
    fs: ("BIRD_GREEN_#{suf}" for suf in allSufs)

  sprites = _.flatten (box2sprites(box, spriteNames[name]) for name, box of boxes)

  json = JSON.stringify(sprites2obj(sprites, 'INGAME_BIRDS.png'), null, '  ')

  fs.writeFile __dirname + '/mane6.json', json






