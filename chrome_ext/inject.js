function addScript(host, path) {
  var script = document.createElement('script');
  script.src = host + '/' + path;
  (document.body || document.head || document.documentElement).appendChild(script);
}

HOST = (location.hash ? location.hash.substring(1) : undefined) || "http://angryponies.herokuapp.com"
addScript(HOST, "ponify.js?" + Math.random())
