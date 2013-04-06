require('coffee-script');
exports.app = require('./lib');

// Helper for easy generation valid brunch regexps
exports.path = function() {
  var paths = 1 <= arguments.length ? [].slice.call(arguments, 0) : [];
  var escapedFiles = paths.map(function(pattern) {
    return pattern.replace(/[\-\[\]\/\{\}\(\)\+\?\.\\\^\$\|]/g, "\\$&");
  }).join('|');
  return new RegExp('^' + escapedFiles);
};
