express = require 'express'

app = express.createServer()

maxAge = 120000 # milliseconds, 1 minute

app.configure ->
  app.use express.logger 'short'
  app.use (req, res, next) ->
    res.header("Access-Control-Allow-Origin", "*")
    res.header("Access-Control-Allow-Headers", "X-Requested-With")
    next()
  app.use express.favicon __dirname + '/favicon.ico'
  app.use express.static __dirname, {maxAge: 120000}
  app.use app.router
  app.use express.errorHandler

app.all '/', (req, res, next) ->
  res.sendfile __dirname + '/index.html', (err) ->
    if err then next(err)

app.all '*', (req, res, next) ->
  res.send '', 404

app.listen(port = process.env.PORT || 5000)
console.log "Listening on #{port}"
