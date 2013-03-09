module.exports = class JSCoverage

  fs: require 'fs'
  spawn: require('child_process').spawn
  exec: require('child_process').exec

  jscov: "#{glob.root}/node_modules/jscoverage/bin/jscoverage"
  mocha: "#{glob.root}/node_modules/mocha/bin/mocha"

  path:
    src: "#{glob.root}/dist/#{glob.config.name}.js"
    jscov:
      unit: "#{glob.root}/temp/cov/unit_#{glob.config.name}.js"
      integration: "#{glob.root}/temp/cov/integration_#{glob.config.name}.js"
    html_cov:
      unit: "#{root}/temp/coverage/unit.html"
      integration: "#{root}/temp/coverage/integration.html"

  exec: require('child_process').exec
  spawn: require('child_process').spawn

  constructor: (options) ->
    try
      @fs.mkdirSync "#{glob.config.path.temp}/reports"
      @fs.mkdirSync "#{glob.config.path.temp}/cov"

    @cmd =
      jscov:
        unit: "#{@jscov} #{@path.src} #{@path.jscov.unit}"
        integration: "#{@jscov} #{@path.src} #{@path.jscov.integration}"
      html_cov:
        unit:
          args: [
            "#{__dirname}/../test.js",
            "-R", "html-cov",
            "--timeout", "6000",
            "--globals", @globals
          ]
        integration:
          args: [
            "#{__dirname}/../test.js",
            "-R", "html-cov",
            "--timeout", "6000",
            "--globals", @globals
          ]

  compile:
    unit: (cb) ->
      @exec @cmd.jscov.unit, (err, stdout, stderr) =>
        cb()  if cb
    integration: (cb) ->
      @exec @cmd.jscov.integration, (err, stdout, stderr) =>
        cb()  if cb

  report:
    unit: (cb)->
      html = ""
      @process.coverage_report = @spawn @bin.mocha, @cmd.report.src.jscoverage.unit.args, @cmd.report.src.jscoverage.unit.options
      @process.coverage_report.stderr.on "data", (data) =>
        console.log data.toString()
      #TODO writable stream
      @process.coverage_report.stdout.on "data", (data) =>
        html += data.toString()
      @process.coverage_report.on "exit", (err, stdout, stderr) =>
        @fs.writeFile @path.report.src.jscoverage.unit, html
        cb()  if cb

    integration: (cb)->
      html = ""
      @process.coverage_report = @spawn @bin.mocha, @cmd.report.src.jscoverage.unit.args, @cmd.report.src.jscoverage.unit.options
      @process.coverage_report.stderr.on "data", (data) =>
        console.log data.toString()
      #TODO writable stream
      @process.coverage_report.stdout.on "data", (data) =>
        html += data.toString()
      @process.coverage_report.on "exit", (err, stdout, stderr) =>
        @fs.writeFile @path.report.src.jscoverage.unit, html
        cb()  if cb
