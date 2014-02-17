Q = require('q')

{BaseView,BaseModel} = require('./base')

# wrap for a nicer API
wait = (delay,fn) -> setTimeout(fn,delay)

# Dummy function to handle errors in AJAX calls, eg: 4XX and 5XX responses
logAjaxError = (jqXHR) -> console.log("#{jqXHR.status}: #{jqXHR.responseText}")

class Stats extends BaseModel
  url: '/stats'
  defaults:
    success: []
    failure: []

  push: (val, property) ->
    return unless property in ['success', 'failure']
    # Use this way to update the properties to trigger the change event.
    ary = _.clone(@get(property))
    ary.push(val)
    @set(property, ary)

  failureCount: -> @get('failure').length
  successCount: -> @get('success').length
  totalCount: -> @successCount() + @failureCount()

class User extends BaseModel
  url: -> "/users/#{@get('id')}"
    
class View extends BaseView
  el: $('.async-container').remove().first().prop('outerHTML')
  elements:
    'button':      '$button'
    '.js-total':   '$total'
    '.js-success': '$success'
    '.js-failure': '$failure'
    '.message':    '$message'

  events:
    'click button.js-start': 'requestUsers'
    'click button.js-reset': 'resetStats'

  constructor: ->
    super
    # Bind (point) elements to data properties of the model
    @point(
      item: @model
      itemAttributes: ['failure']
      element: @$failure
      elementSetter: ({$el, item}) -> $el.text(item.failureCount())).bind()
    @point(
      item: @model
      itemAttributes: ['success']
      element: @$success
      elementSetter: ({$el, item}) -> $el.text(item.successCount())).bind()
    @point(
      item: @model
      itemAttributes: ['failure', 'success']
      element: @$total
      elementSetter: ({$el, item}) -> $el.text(item.totalCount())).bind()
    @

  requestUsers: ->
    @disableControls()
    
    _.reduce([0...100], (promise, id) =>
      promise.then(-> new User(id: id).fetch())
        .then((user) =>
          @model.push(id, if user.isOnline then 'success' else 'failure')
        , logAjaxError)
    , Q())
      .then(=> @model.save())
      .then((=> @logMessage('Stats sent.')), logAjaxError)
      .finally(=> @enableControls().toggleResetButton())
    @

  resetStats: ->
    @model.reset()
    @clearMessage()
    @toggleStartButton()
    @

  disableControls: ->
    @$button.prop('disabled', true)
    @

  enableControls: ->
    @$button.prop('disabled', false)
    @

  toggleStartButton: ->
    @$button.removeClass('js-reset').addClass('js-start').html('Start')
    @

  toggleResetButton: ->
    @$button.removeClass('js-start').addClass('js-reset').html('Reset')
    @

  logMessage: (msg) ->
    @$message.text(msg)
    wait 1*1000, => @clearMessage()
    @

  clearMessage: ->
    @$message.text('')
    @

class App extends BaseView
  elements:
    '.main': '$main'
    
  constructor: ->
    super
    @view = new View(model: new Stats)
    @view.$el.appendTo(@$main)
    @

$(->
  window.app = app = new App(
    el: $('.app')))
