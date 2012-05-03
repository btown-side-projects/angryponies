# Dependencies: caolan async

async = require 'async'
_ = require 'underscore'
$ = require 'jquery-browserify'
log = console?.log || ->

teardownJobs =
  fetchOriginalSite: (cb) ->
    url = url
    $.ajax
      url: url
      dataType: 'html'
      success: (data) ->
        log "successfully loaded #{url}"
        cb(null, data)
  clearTimers: (cb) ->
    TIMERS_TO_SCAN = 1000
    BATCH_SIZE = 100
    batchStart = 0
    test = -> batchStart < TIMERS_TO_SCAN
    iterator = (iterCb) ->
      log "clearTimers starting at #{batchStart}"
      for i in [batchStart...batchStart+BATCH_SIZE]
        clearInterval(i)
        clearTimeout(i)
      batchStart += BATCH_SIZE
      iterCb(null)
    async.whilst test, iterator, cb
  resetDOM: (cb) ->

async.parallel teardownJobs, (err, results) -> 