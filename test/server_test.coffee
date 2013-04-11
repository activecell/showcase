process.env.NODE_ENV ||= 'test'
process.env.PORT     ||= 5001

expect  = require('chai').expect
request = require('supertest')
app     = require('../index').app(__dirname)

describe 'Static server', ->
  before ->
    app.get '/', (req, res) ->
      res.json(200, status: 'OK')

    app.start()

  it '/', (done) ->
    request(app)
      .get('/')
      .expect(200, {status: 'OK'})
      .end(done)
