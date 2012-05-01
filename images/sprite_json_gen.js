(function() {
  var box2sprites, fs, mane6birds, sprites2obj, _;

  fs = require('fs');

  _ = require('underscore');

  box2sprites = function(box, spriteNames) {
    var h, spriteName, w, x, y;
    x = box[0], y = box[1], w = box[2], h = box[3];
    return (function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = spriteNames.length; _i < _len; _i++) {
        spriteName = spriteNames[_i];
        _results.push({
          id: spriteName,
          x: x,
          y: y,
          width: w,
          height: h,
          pivotx: w / 2,
          pivoty: h / 2
        });
      }
      return _results;
    })();
  };

  sprites2obj = function(sprites, image) {
    var i, obj, sprite, _len;
    obj = {
      image: image
    };
    obj.spriteCount = sprites.length;
    for (i = 0, _len = sprites.length; i < _len; i++) {
      sprite = sprites[i];
      obj["sprite_" + i] = sprite;
    }
    return obj;
  };

  (mane6birds = function() {
    var allSufs, basicSufs, box, boxes, json, name, spriteNames, sprites, suf, type;
    boxes = {
      twilight: [221, 10, 71, 63],
      rarity: [124, 6, 92, 59],
      fs: [10, 2, 106, 61],
      pinkie: [25, 80, 95, 65],
      aj: [136, 96, 40, 32],
      rd: [200, 71, 85, 70]
    };
    basicSufs = ['1', '2', 'BLINK', 'FLYING', 'FLYING_YELL', 'YELL'];
    allSufs = basicSufs.concat(['SPECIAL', 'SPECIAL_2', 'SPECIAL_3']);
    spriteNames = {
      pinkie: (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = allSufs.length; _i < _len; _i++) {
          suf = allSufs[_i];
          _results.push("BIRD_BLACK_" + suf);
        }
        return _results;
      })(),
      aj: (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = allSufs.length; _i < _len; _i++) {
          suf = allSufs[_i];
          _results.push("BIRD_BLUE_" + suf);
        }
        return _results;
      })(),
      twilight: _.flatten((function() {
        var _i, _len, _ref, _results;
        _ref = ['RED', 'REDBIG'];
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          type = _ref[_i];
          _results.push((function() {
            var _j, _len2, _results2;
            _results2 = [];
            for (_j = 0, _len2 = allSufs.length; _j < _len2; _j++) {
              suf = allSufs[_j];
              _results2.push("BIRD_" + type + "_" + suf);
            }
            return _results2;
          })());
        }
        return _results;
      })()),
      rarity: (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = allSufs.length; _i < _len; _i++) {
          suf = allSufs[_i];
          _results.push("BIRD_WHITE_" + suf);
        }
        return _results;
      })(),
      rd: (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = allSufs.length; _i < _len; _i++) {
          suf = allSufs[_i];
          _results.push("BIRD_YELLOW_" + suf);
        }
        return _results;
      })(),
      fs: (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = allSufs.length; _i < _len; _i++) {
          suf = allSufs[_i];
          _results.push("BIRD_GREEN_" + suf);
        }
        return _results;
      })()
    };
    sprites = _.flatten((function() {
      var _results;
      _results = [];
      for (name in boxes) {
        box = boxes[name];
        _results.push(box2sprites(box, spriteNames[name]));
      }
      return _results;
    })());
    json = JSON.stringify(sprites2obj(sprites, 'INGAME_BIRDS.png'), null, '  ');
    return fs.writeFile(__dirname + '/mane6.json', json);
  })();

}).call(this);
