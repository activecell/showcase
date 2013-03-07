module.exports = class Watcher
  server_instance: {}

  constructor: (options)->
    global.glob = {}
    @config = glob.config = require("../server/config")
    @compile = require("../server/compiler").compile
    @spawn = require("child_process").spawn
    @exec = require("child_process").exec
    try
      require("fs").mkdirSync __dirname + "/reports"
    @watch()
    @start()

  cover: (cb) ->
    #cmd = __dirname+'/../node_modules/jscoverage/bin/visionmedia-jscoverage '+__dirname+'/../dist/'+glob.config.name+'.js '+__dirname+'/cov/'+glob.config.name+'.js'
    cmd = __dirname + "/../node_modules/jscoverage/bin/jscoverage " + __dirname + "/../dist/" + @config.name + ".js " + __dirname + "/cov/" + @config.name + ".js"
    @exec cmd, (err, stdout, stderr) ->
      cb()  if cb

  watch: (cb)->
    path = __dirname+'/../src/scss/'+@config.name+'.scss'
    require('fs').watch path,(event,filename)->
      console.log event,filename
    cb() if cb

  start: ->
    @compile =>
      @server()
      @cover =>
        @report()
        @spec()

  server: ->
    process.env.NODE_ENV = "development"
    @server_instance.kill()  if @server_instance.kill
    @server_instance = @spawn("node", ["server/run"],
      env: process.env
    )
    @server_instance.stdout.on "data", (data) ->
      process.stdout.write data.toString()

    @server_instance.stderr.on "data", (data) ->
      process.stdout.write data.toString()


  report: (cb) ->
    cmd = "REPORT=1 " + __dirname + "/../node_modules/mocha/bin/mocha " + __dirname + "/run.js -R html-cov -s 20 --timeout 6000 --globals d3,window,_$jscoverage,_$jscoverage_cond,_$jscoverage_done,_$jscoverage_init,_,browser"
    @exec cmd, (err, stdout, stderr) ->
      require("fs").writeFile __dirname + "/reports/coverage.html", stdout
      cb()  if cb

  spec: (cb) ->
    
    #proc = spawn(__dirname+'/../node_modules/mocha/bin/mocha',[__dirname+'/run.js', '-Gw','-R','spec','-s','20','--timeout','6000','--globals','d3,window,_$jscoverage,_$jscoverage_cond,_$jscoverage_done,_$jscoverage_init,_,browser'], {customFds: [0,1,2]})
    proc = @spawn(__dirname + "/../node_modules/mocha/bin/mocha", [__dirname + "/run.js", "-Gw", "-R", "spec", "-s", "20", "--timeout", "6000", "--globals", "d3,window,_$jscoverage,_$jscoverage_cond,_$jscoverage_done,_$jscoverage_init,_,browser"],
      stdio: "inherit"
    )
    
    #proc.stdout.pipe(process.stdout, {end: false})
    proc.on "exit", ->
      @start()
