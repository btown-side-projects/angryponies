(function() {
  var $, async, log, teardownJobs, _;

  async = require('async');

  _ = require('underscore');

  $ = require('jquery-browserify');

  log = (typeof console !== "undefined" && console !== null ? console.log : void 0) || function() {};

  teardownJobs = {
    fetchOriginalSite: function(cb) {
      var url;
      url = url;
      return $.ajax({
        url: url,
        dataType: 'html',
        success: function(data) {
          log("successfully loaded " + url);
          return cb(null, data);
        }
      });
    },
    clearTimers: function(cb) {
      var BATCH_SIZE, TIMERS_TO_SCAN, batchStart, iterator, test;
      TIMERS_TO_SCAN = 1000;
      BATCH_SIZE = 100;
      batchStart = 0;
      test = function() {
        return batchStart < TIMERS_TO_SCAN;
      };
      iterator = function(iterCb) {
        var i, _ref;
        log("clearTimers starting at " + batchStart);
        for (i = batchStart, _ref = batchStart + BATCH_SIZE; batchStart <= _ref ? i < _ref : i > _ref; batchStart <= _ref ? i++ : i--) {
          clearInterval(i);
          clearTimeout(i);
        }
        batchStart += BATCH_SIZE;
        return iterCb(null);
      };
      return async.whilst(test, iterator, cb);
    },
    resetDOM: function(cb) {}
  };

  async.parallel(teardownJobs, function(err, results) {});

}).call(this);
