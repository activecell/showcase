module.exports = class Watcher

  config: require './config'
  utils: new (require './utils')

  process: null

  result: []

  #modules
  fs: require 'fs'

  spawn: require("child_process").spawn
  parallel: require('async').parallel

  lastStart: 0
  timeout: 50

  constructor: (options)->
    @dirs = @config.watch.dirs
    @files = @config.watch.files

    for file in @files
      @result.push file

    @utils.getDirs @config.watch.dirs, (files)=>
      for file in files
        @watch file
      @start()

  watch: (file)->
    @fs.watch file,(event,filename)=>
      if Date.now() - @lastStart > @timeout
        @lastStart = Date.now()
        @kill =>
          process.stdout.write '\u001B[2J\u001B[0;0f'
          @start()

  destroy: (cb)->
    for file in @result
      @fs.unwatchFile file
    @kill =>
      cb() if cb

  kill: (cb)->
    if @process and @process.exitCode is null
      @process.removeAllListeners 'exit'
      @process.on 'exit', =>
        @process.removeAllListeners 'exit'
        @process = null
        cb() if cb
      @process.kill()
    else
      @process = null
      cb() if cb

  start: ->
    @lastStart = Date.now()
    @process = @spawn 'node', [@config.path.runners.start],
      stdio: 'inherit'
      stderr: 'inherit'
