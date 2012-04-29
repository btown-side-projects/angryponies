// For local development, try finding ponify from the local server
var script = document.createElement('script');
script.src = "http://localhost:5000/ponify.js";
(document.body || document.head || document.documentElement).appendChild(script);

// For production, try finding ponify from Heroku
var script2 = document.createElement('script');
script2.src = "http://angryponies.herokuapp.com/ponify.js";
(document.body || document.head || document.documentElement).appendChild(script2);
