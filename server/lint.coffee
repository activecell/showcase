module.exports = class Lint
  config: require './config'

  process: null
  report: null

  command: 'coffeelint'
  args: [
    '-f',
    "#{__dirname}/../coffeelint.json",
    '-r',
    './examples'
    './server'
    './src'
    './test'
  ]
  options:
    stdio: "inherit"

  constructor: (options)->
    @options = options or {}
    @path = "#{@config}/lint.txt"

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
    @process = @spawn command,args,options
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

  run: (cb)->
    @generate =>
      cb() if cb
    @
