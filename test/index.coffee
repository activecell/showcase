global.glob = {}
glob.config = require '../server/config'
glob.url = "http://localhost:#{glob.config.server.port}/"
glob.request = require 'request'
glob.zombie = require 'zombie'

(require './server')('spec')
(require './unit')('spec')
(require './integration')('spec')
