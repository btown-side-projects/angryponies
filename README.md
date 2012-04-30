Angry Ponies
============

[Angry Ponies][1] is a mod of [Angry Birds Chrome][2] that rewrites artwork URLs to use My Little Pony: Friendship is Magic characters instead of birds and pigs.

Released to the public domain by Brenton Partridge, 2012. This is a parody of Angry Birds done under fair use.

### For Non-Technical Artists

We need good artists and sound designers to make this 20% cooler! Namely, there are still lots of birds and pigs that should be ponies, saying pony lines and singing pony songs. Download any of the .png or .mp3 files listed in [allurls.txt][3], make any changes you want (see the difference between [INGAME_BIRDS.png][4] and [INGAME_BIRDS_ponies.png][5] for an example), and [create an issue][6] with a link to your new file. We'll incorporate them as soon as possible! 

Unfortunately, there's no way (yet) for you to test out your changes without having a full Node.js web app development stack. Unlike sharing kindness, this isn't an easy feat, unless you have experience with programming and the command line. If there's substantial interest in this, I'll provide a step-by-step.

### For Developers

Angry Ponies runs on Node.js, with Heroku-compatible deployment scripts. To run a test server, run `node server.js`. When visiting `chrome.angrybirds.com`, the location hash can be used to set the origin of the custom server; this is done automatically if the root of the server is visited.

### Technical Details

Angry Ponies uses a novel technique to intercept all asynchronous HTTP calls, including image tags. Like many HTML5 Canvas games, Angry Birds Chrome loads images to draw to a canvas by setting `img.src` on objects from `new Image(w,h)` or `document.createElement('img')`. While the constructors can be overloaded, there's no (reliable) information at constuction time to determine which element is which, and defining custom setters and getters for `src` can break the browser's drawing code. However, by overloading the constructors to add those objects to a queue, then remapping elements in the queue on the next event tick, the sources can be reset after they are first set to the original content, allowing remapping. Similarly, `XmlHttpRequest.prototype.open` can be remapped for JSON and media requests.

[1]: http://angryponies.herokuapp.com
[2]: http://chrome.angrybirds.com
[3]: https://github.com/bpartridge/angryponies/blob/master/allurls.txt
[4]: https://github.com/bpartridge/angryponies/blob/master/images/INGAME_BIRDS.png
[5]: https://github.com/bpartridge/angryponies/blob/master/images/INGAME_BIRDS_ponies.png
[6]: https://github.com/bpartridge/angryponies/issues/new