module.exports = class Server

  #node modules
  http: require 'http'
  express: require 'express'

  #app modules
  config: require './config'
  Router: require './Router'
  Compiler: require './Compiler'

  
  constructor: (options) ->
    @app = @express()
    @app.configure =>
      @app.set 'port', @config.port
      @app.set 'views', __dirname + '/../examples/views'
      @app.set 'view engine', 'jade'
      @app.use @express.favicon()
      @app.use @express.cookieParser()
      @app.use @express.bodyParser()
      @app.use @express.methodOverride()
      @app.use @app.router
      @app.use @express.static "#{__dirname}/../examples/public/"
      @app.use @express.errorHandler
        dumpExceptions: true
        showStack: true

    @router = new @Router
    @router.bindRoutes @app
    
    @compiler = new @Compiler

  start: ->
    arr = ['testing', 'development']
    if process.env.NODE_ENV in arr
      @modules.http.createServer(app).listen @config.port, =>
        console.log  'server start on port '+@config.port
    else
      @compiler.start =>
        @modules.http.createServer(app).listen @config.port, =>
          console.log  'server start on port '+@config.port
