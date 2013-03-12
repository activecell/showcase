module.exports = class JSCoverage

  fs: require 'fs'
  spawn: require('child_process').spawn
  exec: require('child_process').exec
  parallel: require('async').parallel

  jscov: glob.config.bin.jscov
  mocha: glob.config.bin.mocha

  path: glob.config.path.jscoverage

  globals: "_,d3,browser,window,
    _$jscoverage,_$jscoverage_cond,_$jscoverage_done,_$jscoverage_init
  "

  process:
    unit: null
    integration: null

  constructor: ->
    try
      @fs.mkdirSync @path.coverage_reports
      @fs.mkdirSync @path.cov

    @cmd =
      jscov:
        unit: "#{@jscov} #{@path.src} #{@path.jscov.unit}"
        integration: "#{@jscov} #{@path.src} #{@path.jscov.integration}"
      html_cov:
        unit:
          args: [
            glob.config.path.test_runners.cover_unit,
            "-R", "html-cov",
            "--timeout", "6000",
            "--globals", @globals
          ]
        integration:
          args: [
            glob.config.path.test_runners.cover_integration,
            "-R", "html-cov",
            "--timeout", "6000",
            "--globals", @globals
          ]

  compile_unit: (cb) =>
    @fs.unlink @path.jscov.unit, =>
      @exec @cmd.jscov.unit, (err, stdout, stderr) =>
        cb()  if cb

  compile_integration: (cb) =>
    @fs.unlink @path.jscov.integration, =>
      @exec @cmd.jscov.integration, (err, stdout, stderr) =>
        cb()  if cb

  report_unit: (cb) =>
    @fs.unlink @path.html_cov.unit, =>
      html = ""
      @process.report_unit = @spawn(
        @mocha,
        @cmd.html_cov.unit.args,
        @cmd.html_cov.unit.options
      )
      @process.report_unit.stderr.on "data", (data) =>
        console.log data.toString()
      #TODO writable stream
      @process.report_unit.stdout.on "data", (data) =>
        html += data.toString()
      @process.report_unit.on "exit", (err, stdout, stderr) =>
        start = html.indexOf("<body>")+6
        end = html.indexOf("</body></html>")
        body = html.substr(start, end)
        @fs.writeFile @path.html_cov.unit, body, =>
          cb() if cb

  report_integration: (cb) =>
    @fs.unlink @path.html_cov.integration, =>
      html = ""
      @process.report_integration = @spawn(
        @mocha,
        @cmd.html_cov.integration.args,
        @cmd.html_cov.integration.options
      )
      @process.report_integration.stderr.on "data", (data) =>
        console.log data.toString()
      #TODO writable stream
      @process.report_integration.stdout.on "data", (data) =>
        html += data.toString()
      @process.report_integration.on "exit", (err, stdout, stderr) =>
        @fs.writeFile @path.html_cov.integration, html, =>
          cb() if cb

  run: (cb) ->
    @parallel [@compile_unit,@compile_integration], =>
      @parallel [@report_unit,@report_integration], =>
        cb() if cb

