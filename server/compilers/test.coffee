module.exports = class Test

  spawn: require("child_process").spawn

  mocha: "#{glob.root}/node_modules/mocha/bin/mocha"
  options:
    stdio: "inherit"

  process:
    spec: null

  globals: "_,d3,browser,window"


  constructor: ->
    @args = [
      "#{__dirname}/../test_runners/spec",
      "-G",
      "-R", "spec",
      "-s", "20",
      "--timeout", "6000",
      "--globals", @globals
    ]

  spec: (cb) =>
    console.log 'test spec'
    if @process.spec
      @process.spec.removeAllListeners 'exit'
      @process.spec = null
    @process.spec = @spawn @mocha, @args, @options
    @process.spec.on 'exit', =>
      @process.spec.removeAllListeners 'exit'
      @process.spec = null
      cb() if cb
