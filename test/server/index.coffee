module.exports = (env)->
  assert = require 'assert'
  request = require 'request'
  config = require '../../server/config'
  server_url = "http://localhost:#{config.server.port}"

  describe 'server', ->

    it "test #{server_url}", (done) ->
      request.get server_url, (err,res,body) ->
        assert body
        done()

    it "test #{server_url}/documentation", (done) ->
      request.get "#{server_url}/documentation", (err,res,body) ->
        assert body
        done()

    it "test #{server_url}/performance", (done) ->
      request.get "#{server_url}/performance", (err,res,body) ->
        assert body
        done()

    it "test #{server_url}/test", (done)->
      request.get "#{server_url}/test", (err,res,body) ->
        assert body
        done()

    it "test #{server_url}/coverage", (done) ->
      request.get "#{server_url}/styleguide", (err,res,body) ->
        assert body
        done()

    it "test #{server_url}/styleguide", (done) ->
      request.get "#{server_url}/styleguide", (err,res,body) ->
        assert body
        done()
