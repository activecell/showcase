express  = require('express')
http     = require('http')
path     = require('path')
spawn    = require('child_process').spawn
passport = require('passport')

module.exports = (dirname) ->
  app = express()

  app.set('port', process.env.PORT || 5000)
  app.set('views', dirname + '/views')
  app.set('view engine', 'hbs')

  app.use(express.logger('dev'))
  app.use(express.favicon())
  app.use(express.cookieParser())
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(express.session
    secret: 'super secret shocase session'
    cookie: { maxAge: 60000 * 60 * 24 * 100 } # 100 days
  )
  app.use(passport.initialize())
  app.use(passport.session())
  app.use(express.static(path.join(dirname, 'public')))
  app.use(app.router)
  app.use(express.errorHandler())

  # Convention to start server
  app.start = ->
    # Check configs to use github auth
    if app.get('github-client-id') && app.get('github-client-secret')
      require('./auth')(app, passport)

    # Start server on selected port
    http.createServer(app).listen app.get('port'), ->
      console.log('** Server listening on port %d in %s mode **\n', app.get('port'), app.get('env'))

  app
