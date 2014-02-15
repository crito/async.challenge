express = require('express')

app = express()
require('../routes')(app)

describe 'Routes', ->
  describe 'user API', ->
    it 'respond with JSON', (done) ->
      request(app)
        .get('/users/42')
        .set('Accept', 'application/json')
        .expect('Content-Type', /json/)
        .expect(200, done)

    it 'contains the user id in the response', (done) ->
      request(app)
        .get('/users/42')
        .expect(/"id":"42"/, done)

    it 'contains the online status in the response', (done) ->
      request(app)
        .get('/users/42')
        .expect(/"isOnline":(true|false)/, done)
