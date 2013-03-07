require('coffee-script')
global.glob = {}
glob.config = require('../server/config')
compile = require('../server/compiler').compile

spawn = require('child_process').spawn
exec = require('child_process').exec

compile(function() {
  spec()
});

spec = function (cb) {
  proc = spawn(__dirname+'/../node_modules/mocha/bin/mocha',[__dirname+'/run.js', '-G','-R','spec','-s','20','--timeout','6000','--globals','d3,window,_$jscoverage,_$jscoverage_cond,_$jscoverage_done,_$jscoverage_init,_,browser'], {stdio: 'inherit'})
  proc.on('exit',function() {
  });
};