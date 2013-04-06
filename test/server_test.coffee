process.env.NODE_ENV ||= 'test'
process.env.PORT     ||= 5001

expect  = require('chai').expect
request = require('supertest')
app     = require('../index').app(__dirname)

app.setup ->
  app.get '/', (req, res) ->
    res.json(200, status: 'OK')

describe 'Static server', ->
  it '/', (done) ->
    request(app)
      .get('/')
      .expect(200, {status: 'OK'})
      .end(done)
