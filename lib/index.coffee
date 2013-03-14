express  = require('express')
http     = require('http')
path     = require('path')
spawn    = require('child_process').spawn
passport = require('passport')

module.exports = (dirname) ->
  app = express()

  app.set('port', process.env.PORT || 5000)
  app.set('views', dirname + '/views')
  app.set('view engine', 'jade')

  app.use(express.logger('dev'))
  app.use(express.favicon())
  app.use(express.cookieParser())
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(express.session(secret: 'super secret shocase session'))
  app.use(passport.initialize())
  app.use(passport.session())
  app.use(express.static(path.join(dirname, 'public')))
  app.use(app.router)
  app.use(express.errorHandler())

  require('./auth')(app, passport)

  # Add custom configuration to express server
  # And start server on selected port
  app.setup = (gruntTask, cb) ->
    cb()
    http.createServer(app).listen app.get('port'), ->
      console.log('** Server listening on port %d in %s mode **\n', app.get('port'), app.get('env'))

    grunt = spawn('grunt', [gruntTask])
    grunt.stdout.on 'data', (data) ->
      data = data.toString()
      console.info data.slice(0, data.lastIndexOf('\n'))

  app
