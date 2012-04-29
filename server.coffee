express = require 'express'


app = express.createServer()

app.configure ->
  app.use express.logger 'short'
  app.use (req, res, next) ->
    res.header("Access-Control-Allow-Origin", "*")
    res.header("Access-Control-Allow-Headers", "X-Requested-With")
    next()
  app.use express.static __dirname
  app.use app.router
  app.use express.errorHandler

app.all '/', (req, res, next) ->
  res.sendfile __dirname + '/index.html', (err) ->
    if err then next(err)

app.all '*', (req, res, next) ->
  res.send '', 404

app.listen(process.env.PORT || 3000)
