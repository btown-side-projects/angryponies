function addScript(host, path) {
  var script = document.createElement('script');
  script.appendChild(document.createTextNode("PONIFY_HOST='" + host + "';"));
  (document.body || document.head || document.documentElement).appendChild(script);

  var script2 = document.createElement('script');
  script2.src = host + '/' + path;
  (document.body || document.head || document.documentElement).appendChild(script2);
}

addScript("http://localhost:5000", "ponify.js")
addScript("http://angryponies.herokuapp.com", "ponify.js")
