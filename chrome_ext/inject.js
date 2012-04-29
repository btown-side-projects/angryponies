function addScript(host, path) {
  var script = document.createElement('script');
  script.src = host + '/' + path;
  (document.body || document.head || document.documentElement).appendChild(script);
}

addScript("http://angryponies.herokuapp.com", "ponify.js")
