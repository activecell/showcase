process.env.NODE_ENV = 'testing'

global.assert = require 'assert'
global.should = require('chai').should()
global.glob = {}
glob.server = {}
glob.report = process.env.REPORT
glob.config = require '../server/config'
glob.url = "http://localhost:#{glob.config.port}/"
glob.request = require 'request'
glob.zombie = require 'zombie'

compile = require('../server/compiler').compile

# kill test server, if exist
before (done)->
  url = "#{glob.url}pid?secret=#{glob.config.secret}"
  glob.request.get url, {json: true}, (err,res,body) ->
    if !err
      if res.statusCode is 200 and body
        pid = body.pid
        process.kill pid
        process.exit()
    else
      done()

# run server in test mode
before (done)->
  glob.server = require('child_process').spawn(
    'node'
    [__dirname+'/../server/run.js']
    { env: process.env }
  )
  glob.server.stdout.on 'data', (data) ->
    data = data.toString()
    #process.stdout.write data
    if data is "server start on port #{glob.config.port}\n"
      done()
  glob.server.stderr.on 'data', (data) ->
    #process.stdout.write data.toString()

if glob.report
  require './unit'
else
  require './server'
  require './unit'
  require './integration'
  require './lint'

after (done)->
  if glob.report
    glob.server.kill()
  done()
