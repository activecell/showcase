require('coffee-script')
var fs = require('fs');
var path = __dirname+'/server/watcher';
var path2 = __dirname+'/server/config.coffee';
var watcher;

var lastStart = Date.now()
var timeout = 50
fs.watch(path+'.coffee',function() {
  if (Date.now() - lastStart > timeout) {
    lastStart = Date.now()
    watcher.destroy(function() {
      start()
    });

  }
});

var start = function () {
  delete require.cache[path+'.coffee']
  delete require.cache[path2]
  watcher = new (require(path))();
};

start()
