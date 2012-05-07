function addInlineScript(text) {
  var script = document.createElement('script');
  script.innerHTML = text;
  (document.body || document.head || document.documentElement).appendChild(script);
}

function blockFowl(fowl) {
  // Fowl hasn't arrived yet, so let's make sure its main child script doesn't
  // get injected until we're ready for it.
  
  var TARGET_FORMAT = /\.cache\.js$/;
  function defowl(tagProto) {
    tagProto.fowlAppendChild = tagProto.appendChild;
    tagProto.appendChild = function (child) {
      var parent = this;
      var inject = function () { parent.fowlAppendChild(child) }
      
      if(child.tagName.toUpperCase() == 'SCRIPT' && child.src.match(TARGET_FORMAT)) {
        console.log("Fowl's child script " + child.src + " successfully blocked");
        window.resumeFowl = inject;
      } else {
        inject();
      }
    }
  }
  
  defowl(HTMLHeadElement.prototype);
}

addInlineScript(blockFowl.toString() + ";blockFowl(window.fowl)");
