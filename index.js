require('coffee-script');
exports.app   = require('./lib');
exports.path  = require('./lib/brunch').path;
exports.docco = require('./lib/docco');
exports.defaultConfig = require('./lib/brunch').defaultConfig;