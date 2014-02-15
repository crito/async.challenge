users = require('./users')

module.exports = (app) ->
  app.get('/users/:id', users.show)
