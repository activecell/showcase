module.exports = class Watcher

  process: null

  dirs: [
    'server'
    'src'
    'test'
    'examples/public/coffee'
    'examples/views'
  ]
  files: [
    'start.js'
  ]
  result: []

  #modules
  fs: require 'fs'

  spawn: require("child_process").spawn
  parallel: require('async').parallel

  lastStart: 0
  delayStart: 50

  constructor: (options)->

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

  watch: (file)->
    @fs.watch file,(event,filename)=>
      if Date.now() - @lastStart > @delayStart
        @lastStart = Date.now()
        @kill =>
          @start()

  kill: (cb)->
    if @process
      @process.removeAllListeners 'exit'
      @process.on 'exit', =>
        @process.removeAllListeners 'exit'
        @process = null
        cb() if cb
      @process.kill()
    else
      cb() if cb

  start: ->
    @process = @spawn 'node', ["#{__dirname}/../start.js"],
      stdio: 'inherit'
