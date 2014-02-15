isOnline = ->
  if Math.random() < 0.5 then true else false

module.exports =
  isOnline: isOnline
