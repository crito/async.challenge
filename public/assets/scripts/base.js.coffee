Pointer  = require('pointers').Pointer
MiniView = require('miniview').View
Q = require('q')

class BaseModel extends Backbone.Model
  reset: -> @clear(silent: true).set(@defaults)
  
  # Use Q promises over jQuery's deferred.
  sync: -> Q(Backbone.sync.apply(@, arguments))

class BaseView extends MiniView
  point: (args...) ->
    pointer = new Pointer(args...)
    (@pointers ?= []).push(pointer)
    pointer

  destroy: ->
    pointer.destroy()  for pointer in @pointers  if @pointers
    @pointers = null
    super

module.exports =
  BaseView: BaseView
  BaseModel: BaseModel
