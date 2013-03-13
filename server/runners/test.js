require('coffee-script')
var Server = require('../server');
var server = new Server();
server.start(function() {
  process.exit();
});
