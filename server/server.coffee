module.exports = class Server

  #node modules
  http: require 'http'
  express: require 'express'

  #app modules
  globals: require './globals'
  config: require './config'
  
  constructor: (options) ->
    global.glob = @globals
    @Router = require './router'
    @Build = require './build'

    @port = glob.config.port
    @app = @express()
    @app.configure =>
      @app.set 'port', @port
      @app.set 'views', "#{glob.root}/examples/views"
      @app.set 'view engine', 'jade'
      @app.use @express.favicon()
      @app.use @express.cookieParser()
      @app.use @express.bodyParser()
      @app.use @express.methodOverride()
      @app.use @app.router
      @app.use @express.static "#{glob.root}/examples/public/"
      @app.use @express.errorHandler
        dumpExceptions: true
        showStack: true

    @router = new @Router
    
    @build = new @Build

  listen: (cb)->
    @router.init @app, =>
      @http.createServer(@app).listen @port, =>
        console.log  'server start on port '+@port
        cb() if cb

  start: (cb)->
    @build.compile =>
      console.log 'compiled'
      @listen =>
        console.log 'listened'
        @build.report =>
          @build.spec =>
            console.log 'build done'
            cb() if cb
