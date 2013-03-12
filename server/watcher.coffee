module.exports = class Watcher

  config: require './config'

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
    #fix path
    for dir,d in @dirs
      @dirs[d] = "#{__dirname}/../#{dir}"

    for file in @files
      @result.push "#{__dirname}/../#{file}"

    async = []
    for dir in @dirs
      ((dir)=>
        async.push (done)=>
          @getFiles dir,done
      )(dir)
    @parallel async, =>
      for file in @result
        @watch file
      @start()

  getFiles: (dir,done)->
    @watch dir
    @fs.readdir dir, (err,files)=>
      dirs = []
      if files and files[0]
        for file in files
          if file.split('.')[1]
            @result.push dir+'/'+file
          else
            dirs.push dir+'/'+file
        if dirs[0]
          async = []
          for dir in dirs
            ((dir)=>
              async.push (_done)=>
                @getFiles dir,_done
            )(dir)
          @parallel async, =>
            done()
        else
          done()
      else
        done()
  watch: (file)->
    @fs.watch file,(event,filename)=>
      if Date.now() - @lastStart > @timeout
        @lastStart = Date.now()
        @kill =>
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
    @process = @spawn 'node', ["#{__dirname}/../start.js"],
      stdio: 'inherit'
      stderr: 'inherit'
