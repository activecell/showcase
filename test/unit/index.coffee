describe 'unit tests', ->
  before (done)->
    glob.zombie.visit glob.url, (e, _browser) ->
      browser = _browser
      window = browser.window
      $ = window.$
      _ = window._

      global.browser = browser
      global.window = window
      global.d3 = browser.window.d3
      global._ = window._
      if glob.report
        require("#{__dirname}/../cov/#{glob.config.name}.js")
      done()

  require './base_test'
