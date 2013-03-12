module.exports = (env)->
  global.assert = require 'assert'
  zombie = require 'zombie'
  config = require '../../server/config'
  server_url = "http://localhost:#{config.server.port}"

  describe 'unit tests', ->
    before (done)->
      zombie.visit server_url, (e, _browser) ->
        browser = _browser
        window = browser.window
        $ = window.$
        _ = window._

        global.browser = browser
        global.window = window
        global.d3 = browser.window.d3
        global._ = window._
        if env is 'jscoverage'
          require("#{config.path.temp}/cov/unit_#{config.name}.js")
        done()

    require './base_test'
