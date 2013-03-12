module.exports = class Lint

  process: null
  report: null

  fs: require 'fs'
  spawn: require('child_process').spawn

  coffeelint: require 'coffeelint'

  path: "#{glob.root}/temp/lint.txt"
  command: 'coffeelint'
  args: [
    '-f',
    "#{glob.root}/coffeelint.json",
    '-r',
    "#{glob.root}/examples"
    "#{glob.root}/server"
    "#{glob.root}/src"
    "#{glob.root}/test"
  ]
  options:
    stdio: "inherit"

  constructor: (options)->
    @options = options or {}

  removeAllListeners: ->
    @process.removeAllListeners 'exit'
    @process.stdout.removeAllListeners 'data'
    @process.stderr.removeAllListeners 'data'

  stop: (cb)->
    if @process
      @removeAllListeners()
      @process.on 'exit', =>
        @removeAllListeners()
        @process = null
        cb() if cb
      @process.kill()
    else
      cb() if cb

  generate: (cb)->
    @report = ''
    @process = @spawn @command,@args,@options
    @process.stdout.on 'data', (data) =>
      data = data.toString()
      @report += data
      process.stdout.write data
    @process.stderr.on 'data', (data) =>
      data = data.toString()
      @report += data
      process.stdout.write data

    @process.on 'exit', =>
      @removeAllListeners()
      @process = null
      @fs.writeFile @path, @report, ->
        @report = null
        cb() if cb

  compile: (cb)=>
    @generate =>
      cb() if cb
    @
