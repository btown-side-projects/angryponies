function addAsset(tag, host, path) {
  var asset = document.createElement(tag);
  asset.src = host + '/' + path;
  asset.style.display = 'none';
  document.body.appendChild(asset);
}

HOST = (location.hash ? location.hash.substring(1) : undefined) || "http://angryponies.herokuapp.com"
addAsset("iframe", HOST, "appcache/installer.html")
addAsset("script", HOST, "ponify.js")
console.log("Injected ponify.js");
