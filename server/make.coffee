module.exports = class Make

  config: require './config'
  lint: require './lint'

  fs: require 'fs'

  spawn: require("child_process").spawn
  exec: require("child_process").exec

  globals: "_,
    d3,
    browser, window,
    _$jscoverage,_$jscoverage_cond,_$jscoverage_done,_$jscoverage_init
  "

  process:
    server: null
    coverage_report: null
    spec: null

  server_instance: {}

  constructor: (options) ->
    @options = options or {}
    try
      @fs.mkdirSync @config.path.temp
      @fs.mkdirSync "#{@config.path.temp}/reports"
      @fs.mkdirSync "#{@config.path.temp}/cov"

    @compile = require("../server/compiler").compile

  jscoverage: (cb) ->
    bin = "#{__dirname}/../node_modules/jscoverage/bin/jscoverage"
    src = "#{__dirname}/../dist/#{@config.name}.js "
    dest = "#{__dirname}/../temp/cov/#{@config.name}.js"
    cmd =  "#{bin} #{src} #{dest}"
    @exec cmd, (err, stdout, stderr) =>
      cb()  if cb

  coverage_report: (cb) ->
    html = ""
    _env = {}
    for p of process.env
      _env[p] = process.env[p]
    _env.REPORT = 1

    command = "#{__dirname}/../node_modules/mocha/bin/mocha"
    args = [
      "#{__dirname}/../test.js",
      "-R", "html-cov",
      "--timeout", "6000",
      "--globals", @globals
    ]
    options =
      env: _env
    @process.coverage_report = @spawn command, args, options
    @process.coverage_report.stderr.on "data", (data) =>
      console.log data.toString()
    @process.coverage_report.stdout.on "data", (data) =>
      html += data.toString()
    @process.coverage_report.on "exit", (err, stdout, stderr) =>
      @fs.writeFile __dirname + "/../temp/reports/coverage.html", html
      cb()  if cb

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

  server: (options)->
    unless options?
      options =
        env: 'development'
    @server_instance.kill()  if @server_instance.kill

    process.env.NODE_ENV = options.env
    @server_instance = @spawn "node", ["#{__dirname}/../server/run"],
      env: process.env

    @server_instance.stdout.on "data", (data) =>
      process.stdout.write data.toString()

    @server_instance.stderr.on "data", (data) =>
      process.stdout.write data.toString()
