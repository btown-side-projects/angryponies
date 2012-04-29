(function() {
  var app, express;

  express = require('express');

  app = express.createServer();

  app.configure(function() {
    app.use(express.logger('short'));
    app.use(function(req, res, next) {
      res.header("Access-Control-Allow-Origin", "*");
      res.header("Access-Control-Allow-Headers", "X-Requested-With");
      return next();
    });
    app.use(express.static(__dirname));
    app.use(app.router);
    return app.use(express.errorHandler);
  });

  app.all('/', function(req, res, next) {
    return res.sendfile(__dirname + '/index.html', function(err) {
      if (err) return next(err);
    });
  });

  app.all('*', function(req, res, next) {
    return res.send('', 404);
  });

  app.listen(process.env.PORT || 3000);

}).call(this);