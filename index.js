require('coffee-script');
exports.app           = require('./lib');
exports.casper        = require('./lib/casper');
exports.docco         = require('./lib/docco');
exports.path          = require('./lib/brunch').path;
exports.defaultConfig = require('./lib/brunch').defaultConfig;