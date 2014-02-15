user = require('../lib/user')

exports.show = (req, res) ->
  res.send id: req.param('id'), isOnline: user.isOnline()
