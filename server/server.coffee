module.exports = class Server

  #node modules
  http: require 'http'
  express: require 'express'

  #app modules
  globals: require './globals'
  config: require './config'

  constructor: (options) ->
    global.glob = @globals
    glob.server = @
    @router = new (require './router')
    @build = new (require './build')

    @port = glob.config.server.port
    @app = @express()
    @app.configure =>
      @app.set 'port', @port
      @app.set 'views', @config.path.views
      @app.set 'view engine', 'jade'
      @app.use @express.favicon()
      @app.use @express.cookieParser()
      @app.use @express.bodyParser()
      @app.use @express.methodOverride()
      @app.use @app.router
      @app.use @express.static @config.path.public
      @app.use @express.errorHandler
        dumpExceptions: true
        showStack: true

  listen: (cb)->
    @router.init @app, =>
      @http.createServer(@app).listen @port, =>
        console.log  'server start on port '+@port
        cb() if cb

  show_lint_errors: (cb)->
    if @lint_errors
      errors = false
      length = 0
      for path of @lint_errors
        if @lint_errors[path][0]
          errors = true
        else
          length++

      if errors
        console.log "Lint: #{length} files success,"
        for path of @lint_errors
          if @lint_errors[path][0]
            console.log "  #{path}:"
            for error in @lint_errors[path]
              console.log "    #{error.lineNumber}: #{error.message}"
      else
        console.log "Lint: #{length} files success"
    cb() if cb

  start: (cb)->
    @build.compile (err)=>
      @listen (err)=>
        @build.report (err)=>
          @build.spec (err)=>
            @show_lint_errors (err)=>
              cb() if cb
