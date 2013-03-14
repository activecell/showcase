express = require('express')
http    = require('http')
path    = require('path')

module.exports = (dirname) ->
  app = express()

  app.set('port', process.env.PORT || 5000)
  app.set('views', dirname + '/views')
  app.set('view engine', 'jade')

  app.use(express.logger('dev'))
  app.use(express.favicon())
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(express.static(path.join(dirname, 'public')))
  app.use(app.router)
  app.use(express.errorHandler())

  # Add custom configuration to express server
  # And start server on selected port
  app.setup = (cb) ->
    cb()
    http.createServer(app).listen app.get('port'), ->
      console.log('** Server listening on port %d in %s mode **\n', app.get('port'), app.get('env'))

  app
