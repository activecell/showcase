require('coffee-script')
var Server = require('./server/server');
var server = new Server();
server.start(function() {
  process.exit();
});
