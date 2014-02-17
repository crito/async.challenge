users = require('./users')
stats = require('./stats')

module.exports = (app) ->
  app.get('/users/:id', users.show)
  app.post('/stats', stats.create)
