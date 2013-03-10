module.exports = (env)->
  global.assert = require 'assert'
  describe 'integration', ->
    require './base'
