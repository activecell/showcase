class Server
  config: require './config'
  Router: require './Router'

  modules:
    http: require 'http'
    fs: require 'fs'
    express: require 'express'
    path: require 'path'
    kss: require 'kss'
    jade: require 'jade'
    coffeelint: require 'coffeelint'
    chai: require 'chai'
    #async: require 'async'
  
  constructor: (options) ->
    @app = @modules.express()
    @app.configure =>
      @app.set 'port', @config.port
      @app.set 'views', __dirname + '/../examples/views'
      @app.set 'view engine', 'jade'
      @app.use @modules.express.favicon()
      @app.use @modules.express.cookieParser()
      @app.use @modules.express.bodyParser()
      @app.use @modules.express.methodOverride()
      @app.use @app.router
      @app.use @modules.express.static "#{__dirname}/../examples/public/"
      @app.use @modules.express.errorHandler
        dumpExceptions: true
        showStack: true

    @router = new @Router
      config: @config
      modules: @modules
      server: @
    @router.bindRoutes @app

  start: ->
    compile = require('./compiler').compile

    arr = ['testing', 'development']
    if process.env.NODE_ENV in arr
      glob.modules.http.createServer(app).listen glob.config.port, ->
        console.log  'server start on port '+glob.config.port
    else
      compile ->
        glob.modules.http.createServer(app).listen glob.config.port, ->
          console.log  'server start on port '+glob.config.port

global.server = new Server
server.start()


glob.getSections = (sections, cb) ->
  jadeDir = "#{__dirname}/../examples/views/sections/"
  for section in sections
    section.data.filename = 'tables.scss'
    section.data.description = section.data.description.replace(/\n/g, "<br />")
    jade = null
    try
      jadePath = "#{jadeDir}#{section.reference()}.jade"
      jade = glob.modules.fs.readFileSync jadePath
    if jade
      locals =
        section: section
        className: '$modifier'
      html = glob.modules.jade.compile(jade, {pretty: true})(locals)
      section.data.example = html
      for modifier in section.modifiers()
        a = {className: modifier.className()}
        modifier.data.example = glob.modules.jade.compile(
          jade,
          {pretty: true}
        )(a)
  cb sections

