module.exports = class Watcher

  watch: 
    dirs: [
      'server/'
      'src/'
      'test/'
    ]
    files: [

    ]

  #modules
  fs: require 'fs'

  spawn: require("child_process").spawn
  exec: require("child_process").exec

  make: require './make'

  lastStart: 0
  delayStart: 20

  constructor: (options)->
    @watch()
    @start()

  watch: (cb)->
    path = __dirname+'/../src/scss/'+@config.name+'.scss'
    @fs.watch path,(event,filename)=>
      if Date.now() - @lastStart > @delayStart
        @lastStart = Date.now()
        @start()
        console.log event,filename
    cb() if cb

  start: ->
    @compile =>
      @server()
      @cover =>
        @report()
        @spec()
