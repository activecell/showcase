module.exports = class Watcher

  process: null

  dirs: [
    'server/'
    'src/'
    'test/'
  ]
  files: [
    'start.js'
  ]

  #modules
  fs: require 'fs'

  spawn: require("child_process").spawn

  lastStart: 0
  delayStart: 20

  constructor: (options)->
    @getFiles (files)=>
      for file in files
        @watch file
      @start()

  getFiles: (cb)->
    files = []
    for dir in @dirs
      ((dir)=>
        dir_files = @fs.readdirSync "#{__dirname}/../#{dir}"
        #for dir_file in dir_files
        console.log dir_files
      )(dir)
    for file in @files
      files.push "#{__dirname}/../#{file}"
    cb(files) if cb

  watch: (file)->
    @fs.watch file,(event,filename)=>
      if Date.now() - @lastStart > @delayStart
        @lastStart = Date.now()
        @kill =>
          @start()

  kill: (cb)->
    if @process
      @process.on 'exit', =>
        @process.removeAllListeners 'exit'
        @process = null
        cb() if cb
      @process.kill()
    else
      cb() if cb

  start: ->
    @process = @spawn 'node', ["#{__dirname}/../start.js"]
