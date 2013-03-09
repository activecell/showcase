module.exports = class Spec

  spawn: require("child_process").spawn

  globals: "_,
    d3,
    browser, window,
    _$jscoverage,_$jscoverage_cond,_$jscoverage_done,_$jscoverage_init
  "

  process: null

  spec: (cb) ->
    command = "#{__dirname}/../node_modules/mocha/bin/mocha"
    args = [
      "#{__dirname}/../test.js",
      "-G",
      "-R", "spec",
      "-s", "20",
      "--timeout", "6000",
      "--globals", @globals
    ]
    options =
      stdio: "inherit"
    @process.spec = @spawn command, args, options
    @process.spec.on 'exit', =>
      cb() if cb

