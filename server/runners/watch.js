require('coffee-script')
var fs = require('fs');
var path = __dirname+'/../watcher';
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
  process.stdout.write('\u001B[2J\u001B[0;0f');
  delete require.cache[path+'.coffee']
  watcher = new (require(path))();
};

start()
